class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.9.2.tar.gz"
  sha256 "6bd528c4dbe2276635dc787b6b1f2e5316cf6b49ee3e150264e455a0d68d19c1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be81aafb4cb0d9393362d7d566f176d6a824760f3927b50b9344bcff2dc1edb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be81aafb4cb0d9393362d7d566f176d6a824760f3927b50b9344bcff2dc1edb6"
    sha256 cellar: :any_skip_relocation, monterey:       "0f1c96bc5d6e856c4483de12dc92541eca0326b8c6f56716f955e9db199893eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f1c96bc5d6e856c4483de12dc92541eca0326b8c6f56716f955e9db199893eb"
    sha256 cellar: :any_skip_relocation, catalina:       "0f1c96bc5d6e856c4483de12dc92541eca0326b8c6f56716f955e9db199893eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be81aafb4cb0d9393362d7d566f176d6a824760f3927b50b9344bcff2dc1edb6"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.8" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@3\.\d+$/) }
  end

  def install
    # Install /include and /share/cmake to the global location
    system "cmake", "-S", ".", "-B", "build",
           "-DPYBIND11_TEST=OFF",
           "-DPYBIND11_NOPYTHON=ON",
           *std_cmake_args
    system "cmake", "--install", "build"

    pythons.each do |python|
      # Install Python package too
      site_packages = Language::Python.site_packages python.opt_bin/"python3"
      system python.opt_bin/"python3", *Language::Python.setup_install_args(libexec),
                                       "--install-lib=#{libexec/site_packages}"

      pyversion = Language::Python.major_minor_version python.opt_bin/"python3"
      pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
      (prefix/site_packages/"homebrew-pybind11.pth").write pth_contents

      bin.install libexec/"bin/pybind11-config" => "pybind11-config-#{pyversion}"

      next unless python == pythons.max_by(&:version)

      # The newest one is used as the default
      bin.install_symlink "pybind11-config-#{pyversion}" => "pybind11-config"
    end
  end

  test do
    (testpath/"example.cpp").write <<~EOS
      #include <pybind11/pybind11.h>

      int add(int i, int j) {
          return i + j;
      }
      namespace py = pybind11;
      PYBIND11_MODULE(example, m) {
          m.doc() = "pybind11 example plugin";
          m.def("add", &add, "A function which adds two numbers");
      }
    EOS

    (testpath/"example.py").write <<~EOS
      import example
      example.add(1,2)
    EOS

    pythons.each do |python|
      pyversion = Language::Python.major_minor_version python.opt_bin/"python3"
      site_packages = Language::Python.site_packages python.opt_bin/"python3"

      python_flags = Utils.safe_popen_read(python.opt_bin/"python3-config", "--cflags", "--ldflags", "--embed").split
      system ENV.cxx, "-shared", "-fPIC", "-O3", "-std=c++11", "example.cpp", "-o", "example.so", *python_flags
      system python.opt_bin/"python3", "example.py"

      test_module = shell_output("#{python.opt_bin}/python3 -m pybind11 --includes")
      assert_match (libexec/site_packages).to_s, test_module

      test_script = shell_output("#{opt_bin}/pybind11-config-#{pyversion} --includes")
      assert_match test_module, test_script

      next unless python == pythons.max_by(&:version)

      test_module = shell_output("#{python.opt_bin}/python3 -m pybind11 --includes")
      test_script = shell_output("#{opt_bin}/pybind11-config --includes")
      assert_match test_module, test_script
    end
  end
end

require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.10.3.tgz"
  sha256 "84da94ac403cc99076e12c2a921b32468b90b55a068d6b2766f365b3fe5bb5fd"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d82c68bd47e275514a5b5bc1f1efbe8d479922122e493ffab63638d6ac94cc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d82c68bd47e275514a5b5bc1f1efbe8d479922122e493ffab63638d6ac94cc4"
    sha256 cellar: :any_skip_relocation, monterey:       "643e189fddc0714905d770effec9dfdcc3531f51478c9e996bbbff3207a5b5d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "643e189fddc0714905d770effec9dfdcc3531f51478c9e996bbbff3207a5b5d3"
    sha256 cellar: :any_skip_relocation, catalina:       "643e189fddc0714905d770effec9dfdcc3531f51478c9e996bbbff3207a5b5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d82c68bd47e275514a5b5bc1f1efbe8d479922122e493ffab63638d6ac94cc4"
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end

class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/fd/94/aa1faf2c02b3dc62c6d3ea9c994c6591557bdad59d2b9b35975fe364c5a2/sqlite-utils-3.26.tar.gz"
  sha256 "1b6172f4f118b6ad1d21686c815e0765ae72fb02f1708dc26128032fa8a391da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beac92df77327ed97ac976e23e656b64e71886d6304f5fe99a84fdc055e7399f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc3a7801dec69eb25c2570400933a1892ff98e12c93a8eb4d86b21021a34456d"
    sha256 cellar: :any_skip_relocation, monterey:       "13f12ac5373a09d2575b037eef8431a14dbcf107fae14194a282d827bfbad376"
    sha256 cellar: :any_skip_relocation, big_sur:        "11152041a795d1c13c04e94ddb3ec70a676604a23dfc5dcdca61b119520f508e"
    sha256 cellar: :any_skip_relocation, catalina:       "7f9c82ccd6df0065427b0d6b17c78ecf378b57aa9b189e706b2f3fc154cefffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab1b8552e1075ddba5fee7ac1254efa358858dc19b63ba866b81406e52df7ec4"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/42/e1/4cb2d3a2416bcd871ac93f12b5616f7755a6800bccae05e5a99d3673eb69/click-8.1.2.tar.gz"
    sha256 "479707fe14d9ec9a0757618b7a100a0ae4c4e236fac5b7f80ca68028141a1a72"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/62/30/63e64b7b8fa69aabf97b14cbc204cb9525eb2132545f82231c04a6d40d5c/sqlite-fts4-1.0.1.tar.gz"
    sha256 "b2d4f536a28181dc4ced293b602282dd982cc04f506cf3fc491d18b824c2f613"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end

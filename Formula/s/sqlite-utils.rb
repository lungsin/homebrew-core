class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/73/4f/a652fe1b36ac71f7f7bd85219f233d3619f327efcfe0a1c235b262a5ab53/sqlite-utils-3.35.tar.gz"
  sha256 "8f6fe7f8d12772cd5cf4594703a98dcd0c37c0fd6820dd20541ba74b9fca363a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4648bd291f0ab3428840f5e67801f212251f5f95766c59a25ecd0b2618373c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38c429ccccd02239c6b9bc0387da72534db57586277fc34be4ca0c327309f60d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7830e15e76f117a66d63623196f003edd234bc786547a6a6ec355e26e6109370"
    sha256 cellar: :any_skip_relocation, ventura:        "a2040a1278e9091dbfeacd52c067cd99a042529a3365c1e6102a470d759b86ac"
    sha256 cellar: :any_skip_relocation, monterey:       "3174c772dd1167e7d412389289f50d712151936438b525af2dd4d5c9b4a8e372"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d75779a9c953cd238eb131115b38f247eb97bb68ffe4ea8605ad536d0ae7f0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6f5c304e3355d8eb5eb99912b41131851e19935377ba695f38872e2591cd97f"
  end

  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-default-group-wheel" do
    url "https://files.pythonhosted.org/packages/3d/da/f3bbf30f7e71d881585d598f67f4424b2cc4c68f39849542e81183218017/click-default-group-wheel-1.2.2.tar.gz"
    sha256 "e90da42d92c03e88a12ed0c0b69c8a29afb5d36e3dc8d29c423ba4219e6d7747"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/8a/42/8f2833655a29c4e9cb52ee8a2be04ceac61bcff4a680fb338cbd3d1e322d/pluggy-1.2.0.tar.gz"
    sha256 "d12f0c4b579b15f5e054301bb226ee85eeeba08ffec228092f8defbaa3a4c4b3"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/c2/6d/9dad6c3b433ab8912ace969c66abd595f8e0a2ccccdb73602b1291dbda29/sqlite-fts4-1.0.3.tar.gz"
    sha256 "78b05eeaf6680e9dbed8986bde011e9c086a06cb0c931b3cf7da94c214e8930c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end

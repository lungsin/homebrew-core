class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.37.0.tgz"
  sha256 "22050dfd8249fc5f8cb50bb417751a8071c6f93027adf4e73cb76c7442201025"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "3b251f6bf7d0ccd48cdaee0f9247dd484454442646438a048b30996e6f6d6416"
    sha256                               arm64_sonoma:  "ff48af0980912bcdb42706c08d11c2c876d390e7fc88a1f3dd85eb7609d3765b"
    sha256                               arm64_ventura: "c9d6c36c0a701833ffaab2be562d4e10c8587c9c70108d933968044495352842"
    sha256                               sonoma:        "6d0ecdb746cc1cff9984142f0cfdf5608be646b4c4e52b1cb2c6e85f3f51fdcb"
    sha256                               ventura:       "59931de3b51bf2f5893db7d20822c68b7af4b146d8c34c721315a4200bb000b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d77d450af6d8f8127fb870f2e0735fb2bcaaad916bbdd4e8122ed0f7957fb46"
  end

  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "gmp"
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"

    if OS.linux?
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end

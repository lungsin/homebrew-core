class Ghostty < Formula
  desc "👻 Ghostty is a fast, feature-rich, and cross-platform terminal emulator that uses platform-native UI and GPU acceleration."
  homepage "https://ghostty.org/"
  url "https://release.files.ghostty.org/1.0.0/ghostty-source.tar.gz"
  sha256 "7fcb5fed08bd23d54be138af4f63a78cf5addddbe40322465b520cf14c46f181"
  license "MIT"
  head "https://github.com/lungsin/ghostty.git", branch: "chore/pkg-config-libadwaita"

  depends_on "zig" => :build

  on_linux do
    depends_on "gtk4"
    depends_on "libadwaita"
    depends_on "pkg-config"
  end

  def install
    system "zig", "build", "-Doptimize=ReleaseFast"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test ghostty`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    system "false"
  end
end

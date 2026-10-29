# Homebrew formula for sketchprobe. It installs the prebuilt native executable from the GitHub Release:
# no Java, no compiling. Files installed by Homebrew are not quarantined by macOS, so there is no
# "unidentified developer" dialog (a direct download would need code signing, which is out of scope).
#
# The version in the URLs and the checksums below are filled in by packaging/homebrew/update-formula.sh from a
# release's SHA256SUMS; the release workflow attaches the result to the release as sketchprobe.rb.
class Sketchprobe < Formula
  desc "Inspect and decode Apache DataSketches binaries"
  homepage "https://github.com/yadavan88/sketchprobe"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/yadavan88/sketchprobe/releases/download/v0.1.3/sketchprobe-macos-arm64.tar.gz"
      sha256 "cb2401058da65610fc99cce0a30c2828534371ae213abe7c16cd5cb3d58a7e6c" # macos-arm64
    end

    on_intel do
      url "https://github.com/yadavan88/sketchprobe/releases/download/v0.1.3/sketchprobe-macos-x86_64.tar.gz"
      sha256 "65a9f03a1a8ee4a854841a143e862ba890f8ab6af165c82bf915e4360d4f340c" # macos-x86_64
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/yadavan88/sketchprobe/releases/download/v0.1.3/sketchprobe-linux-x86_64.tar.gz"
      sha256 "47c6ee395ac3a4da085b27ac3696924b33dbb8672a5b095589ccd768887307fe" # linux-x86_64
    end
  end

  def install
    bin.install "sketchprobe"
    doc.install "LICENSE", "NOTICE"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sketchprobe --version")
    # An empty Frequency sketch (8 bytes), given as hex, is decoded and named.
    output = pipe_output("#{bin}/sketchprobe --input-format hex", "01010a0303050000")
    assert_match "Frequency", output
    # Empty input is refused with status 1.
    shell_output("#{bin}/sketchprobe < /dev/null", 1)
  end
end

using BinaryProvider

# This is where all binaries will get installed
const prefix = Prefix(joinpath(@__DIR__, "usr"))

# Instantiate products here.  Examples:
earcut = LibraryProduct(prefix, "earcut")
# foo_executable = ExecutableProduct(prefix, "fooifier")
# libfoo_pc = FileProduct(joinpath(libdir(prefix), "pkgconfig", "libfoo.pc"))

# Assign products to `products`:
products = [earcut]


# Download binaries from hosted location
bin_prefix = "https://github.com/SimonDanisch/EarCutDeps/releases/download/v0.1.3"
# Listing of files generated by BinaryBuilder:
download_info = Dict(
    BinaryProvider.Linux(:aarch64, :glibc) => ("$bin_prefix/Earcut.aarch64-linux-gnu.tar.gz", "53c308340c68dbf3d06f4536f8e64eae50def534fc6e0e091f2d6b7841c51963"),
    BinaryProvider.Linux(:armv7l, :glibc) => ("$bin_prefix/Earcut.arm-linux-gnueabihf.tar.gz", "ad2aca45439d1672cff4ec06cd631f06cea717b877a2bbb6767bff256551e760"),
    BinaryProvider.Linux(:i686, :glibc) => ("$bin_prefix/Earcut.i686-linux-gnu.tar.gz", "11b3261b92492a45d555dfbc56688f59527a3e9d135aee45dce22e3181b46253"),
    BinaryProvider.Windows(:i686) => ("$bin_prefix/Earcut.i686-w64-mingw32.tar.gz", "60538ca1b856c0c28340d124636d4cf23c6e06a9bcd9e099dabca0b121641fe7"),
    BinaryProvider.Linux(:powerpc64le, :glibc) => ("$bin_prefix/Earcut.powerpc64le-linux-gnu.tar.gz", "f1d4b36e6d20671dc538d87092163fcf38554cb01873e4ffbb6ebc913f559c6e"),
    BinaryProvider.MacOS() => ("$bin_prefix/Earcut.x86_64-apple-darwin14.tar.gz", "bec5531da9f87a010a7543c1671aac8984dd5478cd15f7328d4be7666af6ee3e"),
    BinaryProvider.Linux(:x86_64, :glibc) => ("$bin_prefix/Earcut.x86_64-linux-gnu.tar.gz", "e620c7ad124fdc30d416cfd03c9769f16b6bbc6fe8b37cd8af5803bb3adaa37d"),
    BinaryProvider.Windows(:x86_64) => ("$bin_prefix/Earcut.x86_64-w64-mingw32.tar.gz", "1234d5b140a8a7090587cdce6a5f2d02c04b5652f0df7e66f2063ebfe0c6f8a4"),
)
if platform_key() in keys(download_info)
    # First, check to see if we're all satisfied
    if any(!satisfied(p; verbose=true) for p in products)
        # Download and install binaries
        url, tarball_hash = download_info[platform_key()]
        @show url
        install(url, tarball_hash; prefix=prefix, force=true, verbose=true)
    end

    # Finally, write out a deps.jl file that will contain mappings for each
    # named product here: (there will be a "libfoo" variable and a "fooifier"
    # variable, etc...)
    @write_deps_file earcut
else
    error("Your platform $(Sys.MACHINE) is not supported by this package!")
end

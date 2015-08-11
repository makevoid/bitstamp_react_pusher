require 'bundler'
Bundler.require


Opal.append_path "./"

File.binwrite(
  "dist/bundle.js",
    Opal::Builder.build("bundle").to_s
)

# TODO:
#
#     if output ~= "An error occurred while compiling"
#
#       alert user:
#
#         t'ha shalao (autodetect dependencies)

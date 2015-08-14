require 'bundler'
Bundler.require


Opal.append_path "./"

File.binwrite(
  "dist/bundle.js",
    Opal::Builder.build("bundle").to_s
)

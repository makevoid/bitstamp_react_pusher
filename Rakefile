task default: :run

task :run do
  IO.popen "bundle exec guard"
  IO.popen "python -m SimpleHTTPServer 3000"
  sleep
end

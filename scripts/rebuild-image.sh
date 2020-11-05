rm -rf public/packs

NODE_ENV=production RALS_ENV=production bundle install && rake assets:precompile

docker build -t "siteinspector/siteinspector" .

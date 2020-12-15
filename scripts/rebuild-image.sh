rm -rf public/packs

NODE_ENV=production RALS_ENV=production bundle install && rake assets:precompile

docker buildx build --push -t "siteinspector/siteinspector:latest" --platform linux/amd64,linux/arm64 .

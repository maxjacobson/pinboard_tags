require 'pinboard'
require 'irb'
require 'json'
require 'ostruct'

token = File.read("./token").chomp
$pinboard = Pinboard::Client.new(:token => token)

$tags_file_cache = tags_file_cache = "./tags_file_cache"

class Tag < OpenStruct
  def destroy
    # Should bust cache if you actually remove the tag...
    # FileUtils.rm($tags_file_cache)
    binding.irb
  end

  def posts
    $pinboard.posts(tag: tag)
  end
end

tags =
  if File.exist?(tags_file_cache)
    puts "Loading tags from cache (delete #{tags_file_cache} to bust cache)"
    JSON.load(File.read(tags_file_cache)).map { |tag| Tag.new(tag) }
  else
    puts "Loading tags and caching for next time"
    tags = $pinboard.tags_get.map(&:to_h)
    File.open(tags_file_cache, "w") { |f| f.write(JSON.dump(tags)) }
    tags.map { |tag| Tag.new(tag) }
  end

puts "local variable `tags` has all your tags..."
binding.irb

4

infile = ARGV[0]

file = File.new(infile, "r")
first_line = file.gets.split(' ').map(&:to_i)

n_videos = first_line[0]
n_endpoints = first_line[1]
n_requests = first_line[2]
n_caches = first_line[3]
cache_size = first_line[4]

video_sizes = file.gets.split(' ').map(&:to_i)

rand = Random.new

# {enpoint_id => {cache_id => latency}}
endpoints = Hash.new {|hash, key| hash[key] = {}}
endpoint_datacenter_lat = {}

n_endpoints.times do |i|
  e = file.gets.split(' ').map(&:to_i)
  endpoint_datacenter_lat[i] = e[0]
  endpoint_caches = e[1]

  endpoint_caches.times do |j|
    e_cache = file.gets.split(' ').map(&:to_i)
    cache_id = e_cache[0]
    cache_latency = e_cache[1]

    endpoints[i][cache_id] = cache_latency 
  end  
end

caches = {}
caches_rem_size = {}
n_caches.times do |i|
  caches[i] = []
  caches_rem_size[i] = cache_size
end

n_caches.times do |i|
  print("\r#{i}/#{n_caches}             ")
  rem_size = caches_rem_size[i]

  retries = 0
  while rem_size > 0 || retries < 20
    video = rand.rand(n_videos)
    video_size = video_sizes[video]

    if rem_size - video_size >= 0
      caches[i] << video
      rem_size -= video_size
    else
      retries += 1
    end
  end
end

file = File.new("#{infile}.out", "w")


File.open("#{infile}.out", "w") do |file| 
  used_caches = n_caches
  file.write("#{used_caches}\n")
  used_caches.times do |i|
    file.write("#{i} #{caches[i].join(' ')}\n")
  end
end
#puts(caches)

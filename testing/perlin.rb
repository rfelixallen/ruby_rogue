require 'perlin_noise'

noise = Perlin::Noise.new 1, :interval => 200 # 1 is the dimension, interval is the noise generator

0.step(300, 0.1).each do |x|
	n = rand(0..100)
	if n < 20
		puts '#' * (noise[x] * 60).floor
	elsif n > 20 and n < 60 
		puts '~' * (noise[x] * 60).floor
	else
		puts '@' * (noise[x] * 60).floor
	end
	#puts n
end
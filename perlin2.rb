def GenerateWhiteNoise(width, height)
	random = Random.new(0).rand # Random number using 0 as seed
	noise = Array.new(width) {Array.new(height)}

	i = 0
	while i < width
		j = 0
		while j < height
			noise[i][j] = random % 1
			#puts noise[i][j]
			j += 1
		end
		i += 1
	end
	print noise
	#return noise
end

GenerateWhiteNoise(10,10)
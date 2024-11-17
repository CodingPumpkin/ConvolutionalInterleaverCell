using Plots
x = range(0, 1, length=400)

y = @. sin(x) + 0.001 * randn()
plot(x,y)

function convolutionalinterleaver_shiftregisters(inputdata::Vector{Q}, number::Int, size::Int, initialconditions::Q) :: Vector{Q} where Q
	outputdata = Vector{typeof(initialconditions)}(undef, length(inputdata))
	shiftregisters = fill(initialconditions, (13, 7))
	readindex = 1
	writeindex = 1
	while readindex+size < length(inputdata)
		for j in 1:number
			shiftregisters[j, 1:size] = reverse(inputdata[readindex:(readindex+size-1)])
			readindex += size			
			if readindex >= length(inputdata)
				break
			end  
		end
		for j in 1:number
			outputdata[writeindex:writeindex+size-1] = shiftregisters[j, 1:size]
			writeindex += size
			if readindex >= length(inputdata)
				break
			end
		end
	end
	outputdata[writeindex:length(inputdata)] = inputdata[writeindex:length(inputdata)]
	return outputdata
end

plot(x, [y, convolutionalinterleaver_shiftregisters(y, 13, 7)])
using Plots
x = range(0, 1, length=400)

y = @. sin(x) + 0.001 * randn()
plot(x,y)

function convolutionalinterleaver_shiftregisters(inputdata::Vector{Q}, number::Int, size::Int, initialconditions::Q) :: Vector{Q} where Q
	outputdata = Vector{typeof(initialconditions)}(undef, length(inputdata))
	shiftregisters = fill(initialconditions, (number, size))
	readindex = 1
	writeindex = 1
	while readindex+size-1 < length(inputdata)
		for j in 1:number
			if readindex+size >= length(inputdata)
				break
			end  
			shiftregisters[j, 1:size] = reverse(inputdata[readindex:(readindex+size-1)])
			readindex += size			
		end
		for j in 1:number
			if writeindex+size >= length(inputdata)
				break
			end
			outputdata[writeindex:writeindex+size-1] = shiftregisters[j, 1:size]
			writeindex += size
		end
	end
	outputdata[writeindex:length(inputdata)] = reverse(inputdata[writeindex:length(inputdata)])
	return outputdata
end

function initshiftregisters(maxregistersize::Int, numberofregisters::Int, registerlengthstep::Int, initialconditions::T)::Vector{Vector{T}} where T
	registers = fill([], numberofregisters)
	if registerlengthstep > 0
		registers[1] = [initialconditions]
		for n in 2:numberofregisters
			registers[n] = fill(initialconditions, (n-1)*registerlengthstep+1)
		end
	elseif registerlengthstep == 0
		for n in 1:numberofregisters
			registers[n] = fill(initialconditions, maxregistersize)
		end
	end
	return registers
end

function convinterleaver_fancyshiftregisters(y::Vector{Q}, numberofregisters::Int, registerlengthstep::Int, initialconditions::Q)::Vector{Q} where Q
	framesize = length(y)
	maxsize = 8 #I decided to use this value as a default one
	if registerlengthstep > 0
		maxsize = (numberofregisters-1)*registerlengthstep	
	end
	outputdata = fill(initialconditions, framesize)
	shiftregisters = initshiftregisters(maxsize, numberofregisters, registerlengthstep, initialconditions)
	readindex = 1
	writeindex = 1
	while readindex < framesize
		for n in 1:numberofregisters
			for k in 1:length(shiftregisters[n])
				if readindex == framesize+1
					break
				end
				shiftregisters[n][k] = y[readindex]
				readindex += 1
			end
		end
		for n in 1:numberofregisters
			for k in 1:length(shiftregisters[n])
				if writeindex == framesize+1
					break
				end
				outputdata[writeindex] = shiftregisters[n][length(shiftregisters[n])+1-k]
				writeindex += 1
			end
		end
 	end
	println(outputdata)
	return outputdata
end

plot(x, [y, convolutionalinterleaver_shiftregisters(y, 13, 7)])

plot(x, [y, convinterleaver_fancyshiftregisters(y, 6, 0, 0.0)])

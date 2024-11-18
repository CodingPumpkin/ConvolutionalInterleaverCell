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

plot(x, [y, convolutionalinterleaver_shiftregisters(y, 13, 7)])

# ConvolutionalInterleaverCell

Function `convolutionalinterleaver_shiftregisters` accepts a vector of values as input and performs convolutional interleaving imitating work of `number` shift registers with capacity to store `size` values. `initial condition` values should always be specified. They are added in an attempt to comply with convolutional interleaver block parameters from matlab.
Alternative function uses "fancy" (or in my understanding more simulink-like) shift registers that are configurable in amount and size.

#include "mapping.h"


uint64_t getBytesAsNumber(char* chunk_start, size_t num_bytes, ByteOrder endianness)
{
	
	uint64_t ret = 0;
	int n = 0;
	uint8_t byte = 0;
	uint64_t temp = 0;
	switch(endianness)
	{
		
		case LITTLE_ENDIAN:
			while(n < num_bytes)
			{
				byte = (uint8_t)*(chunk_start + n);
				temp = byte;
				temp = temp << (8 * n);
				ret += temp;
				n++;
			}
			break;
		
		case BIG_ENDIAN:
			while(n < num_bytes)
			{
				byte = (uint8_t)*(chunk_start + n);
				temp = byte;
				temp = temp << (8 * (num_bytes - n - 1));
				ret += temp;
				n++;
			}
			break;
		
	}
	return ret;
	
}


double convertHexToFloatingPoint(uint64_t hex)
{
	double ret;
	hex = (uint64_t)hex;
	
	//sign bit 63
	double sign = 1 - 2*(hex >> 63);
	
	//exponent field bits 62-52
	int16_t exponent = (int16_t)(((hex << 1) >> (52 + 1)) - 1023);
	
	//significand bits 51-0, shift back later for fewer operations
	uint64_t significand = (hex << 12);
	
	if(exponent >= 0)
	{
		ret = sign * (1 << exponent);
	}
	else
	{
		ret = sign / (1 << (-exponent));
	}
	
	double sum = 1;
	double b_i;
	for(int i = 0; i <= 51; i++)
	{
		b_i = (significand << i) >> 63;
		sum += b_i / ((uint64_t)1 << (i + 1));
	}
	
	return ret * sum;
}


int roundUp(int numToRound)
{
	int remainder = numToRound % 8;
	if(remainder == 0)
	{
		return numToRound;
	}
	
	return numToRound + 8 - remainder;
}


//indices is assumed to have the same amount of allocated memory as dims
//indices is an out parameter
void indToSub(int index, const uint32_t* dims, uint32_t* indices)
{
	int num_dims = 0;
	int num_elems = 1;
	int i = 0;
	while(dims[i] > 0)
	{
		num_elems *= dims[i];
		num_dims++;
	}
	
	indices[0] = (index + 1) % dims[0];
	
	int divide = dims[0];
	int mult = 1;
	int sub = indices[0] * mult;
	
	for(i = 1; i < num_dims - 1; i++)
	{
		indices[i] = ((index + 1 - sub) / divide) % dims[i];
		divide *= dims[i];
		mult *= dims[i - 1];
		sub += indices[i] * mult;
	}
	
	divide *= dims[num_dims - 1];
	mult *= dims[num_dims - 2];
	sub += indices[num_dims - 2];
	indices[num_dims - 1] = (index + 1 - sub) / divide;
}
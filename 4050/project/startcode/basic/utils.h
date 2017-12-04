#ifndef _UTILS_H
#define _UTILS_H


#define square(x) ((x)*(x))

#define max2(x,y) (((x)>=(y))?(x):(y))
#define min2(x,y) (((x)>=(y))?(y):(x))
#define max3(x,y,z) (((x)>=(y)&&(x)>=(z))?(x):(((y)>=(x)&&(y)>=(z))?(y):(z)))
#define min3(x,y,z) (((x)<=(y)&&(x)<=(z))?(x):(((y)<=(x)&&(y)<=(z))?(y):(z)))
#define max4(x,y,z,w) (max2(max2((x),(y)),max2((z),(w))))
#define min4(x,y,z,w) (min2(min2((x),(y)),min2((z),(w))))
#define mid3(x,y,z) ( (((y)<(x))&&((x)<(z))) ? (x) : \
		      ( (((z)<(x))&&((x)<(y))) ? (x) : \
		        ( (((x)<(y))&&((y)<(z))) ? (y) : \
		          ( (((z)<(y))&&((y)<(x))) ? (y) : (z) ))))

// Set the mask by Wolfgang
// Mask of end even vertices for interior odd vertices
#define IN_ODD_ADJ 3.0/8.0
// Mask of opposite even vertices for interior odd vertices
#define IN_ODD_OPP 1.0/8.0
// Mask of end even vertices for boundary odd vertices
#define BD_ODD_ADJ 1.0/2.0
// Mask for interior even vertices whose degrees are equals to 3
#define IN_EVEN_E3 7.0/16.0
#define IN_EVEN_E3_NEIBOR 3.0/16.0
// Mask for interior even vertices whose degrees are greater than 3
#define IN_EVEN_G3 3.0/8.0
// Mask of end even vertices for boundary odd vertices

// Set limit subdivison time by Wolfgang
#define SUB_LIMIT 4

// NOTE:  These primes are used for hashing, and should
// not be the same as any of the primes used as sizes of
// the hash tables (see utils.cpp)
#define LARGE_PRIME_A 10007
#define LARGE_PRIME_B 11003
#define LARGE_PRIME_C 12007
#define LARGE_PRIME_D 13001

// a list of primes...  roughly 2 times as big as previous
//  chosen randomishly from a web listing
static  unsigned int  primes[] = {
        11,
        37,
        79,
       127,
       239,
       421,
      1021,
      2383,
      5749,
      7127,
     10079,
     13627,
     16007,
     21163,
     46307,
     78191,
    100459,
    213977,
    453137,
   1299827,
   2599829,
   5399833,
  11099833,
  24099857,
  52099877,
 100000000};

#define MAX_PRIME 100000000

inline int NextLargestPrime(unsigned int x) {
  if (x > MAX_PRIME) {
    printf("ERROR! requested size (%d) for hash table is too large (max %d)\n",
	   x, MAX_PRIME);
    return x;
  }
  int i = 0;
  while (x > primes[i]) i++;
  return primes[i];
}

#endif

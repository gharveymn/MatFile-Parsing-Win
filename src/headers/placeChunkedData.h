#ifndef PLACE_CHUNKED_DATA_H
#define PLACE_CHUNKED_DATA_H


#include "getDataObjects.h"
#include "mtezq.h"
#ifdef GMV_64_BIT
#include "../extlib/libdeflate/x64/libdeflate.h"
#else
#include "../extlib/libdeflate/x86/libdeflate.h"
#endif


typedef enum
{
	GROUP = 0, CHUNK, NODETYPE_UNDEFINED, NODETYPE_ROOT, RAWDATA, SYMBOL
} NodeType;

//typedef enum
//{
//	LEAFTYPE_UNDEFINED, RAWDATA, SYMBOL
//} LeafType;

typedef struct
{
	uint32_t chunk_size;
	//uint32_t filter_mask;
	index_t* chunk_start;
	//address_t local_heap_offset;
} Key;

typedef struct tree_node_ TreeNode;
struct tree_node_
{
	address_t address;
	NodeType node_type;
	//LeafType leaf_type;
	//int16_t node_level;
	uint16_t entries_used;
	Key** keys;
	TreeNode** children;
};

typedef struct
{
	Data* object;
	MTQueue* mt_data_queue;
#ifdef WIN32_LEAN_AND_MEAN
	CONDITION_VARIABLE* thread_sync;
	CRITICAL_SECTION* thread_mtx;
#else
	pthread_cond_t* thread_sync;
	pthread_mutex_t* thread_mtx;
#endif
	bool_t* main_thread_ready;
	error_t err;
} InflateThreadObj;

typedef struct
{
	Key* data_key;
	TreeNode* data_node;
} DataPair;

typedef struct
{
	TreeNode* node;
	uint8_t num_chunked_dims;
	error_t err;
} FillNodeObj;

error_t fillNode(TreeNode* node, uint8_t num_chunked_dims);
error_t decompressChunk(Data* object);
#ifdef WIN32_LEAN_AND_MEAN
DWORD doInflate_(void* t);
DWORD mt_fillNode(void* fno);
#else
void* doInflate_(void* t);
void* mt_fillNode(void* fno);
#endif
void freeTree(void* n);
error_t getChunkedData(Data* obj);
index_t findArrayPosition(const index_t* chunk_start, const index_t* array_dims, uint8_t num_chunked_dims);
void memdump(const char type[]);
void makeChunkedUpdates(index_t* chunk_update, const index_t* chunked_dims, const index_t* dims, uint8_t num_dims);
void* garbageCollection_(void* nothing);
void startThreads_(void* thread_startup_obj);

//pthread_t gc;
//pthread_attr_t attr;
bool_t is_working;

#endif //PLACE_CHUNKED_DATA_H

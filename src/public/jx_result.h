// Copyright & License details are available under JXCORE_LICENSE file

#ifndef SRC_PUBLIC_JX_RESULT_H
#define SRC_PUBLIC_JX_RESULT_H

#include <stdlib.h>
#include <stdint.h>

#define  __WINDLL_EXPORT__		__declspec(dllexport)

/**
 * Ugly, 
 */
#undef JXCORE_EXTERN

#if   !defined(JXCORE_EXTERN) && defined(_MSC_VER)
#define JXCORE_EXTERN(x)	__WINDLL_EXPORT__ x
#elif !defined(JXCORE_EXTERN) && ( defined(__MINGW32__) || defined(__CYGWIN__))
#define JXCORE_EXTERN(x)	__attribute__((visibility ("default"))) __WINDLL_EXPORT__ x
#elif !defined(JXCORE_EXTERN) && defined(__GNUC__)
#define JXCORE_EXTERN(x)	__attribute__((visibility ("default")))	x
#elif !defined(JXCORE_EXTERN)
#define JXCORE_EXTERN(x)	x
#endif /* JXCORE_EXTERN */

#ifdef __cplusplus
extern "C" {
#endif

enum _JXType {
  RT_Int32 = 1,
  RT_Double = 2,
  RT_Boolean = 3,
  RT_String = 4,
  RT_Object = 5,
  RT_Buffer = 6,
  RT_Undefined = 7,
  RT_Null = 8,
  RT_Error = 9,
  RT_Function = 10
};

typedef enum _JXType JXResultType;
typedef enum _JXType JXValueType;

struct _JXValue {
  // internal use only
  void *com_  ;
  void *data_ ;
  size_t size_;

  uint8_t persistent_;
  uint8_t was_stored_;
  uint8_t type_;
  uint8_t			jx____pad___8;
};

typedef struct _JXValue JXResult;
typedef struct _JXValue JXValue;

JXCORE_EXTERN(bool)
JX_CallFunction(JXValue *fnc, JXValue *params, const int argc, JXValue *out);

JXCORE_EXTERN(bool)
JX_MakePersistent(JXValue *value);

JXCORE_EXTERN(bool)
JX_ClearPersistent(JXValue *value);

JXCORE_EXTERN(bool)
JX_IsFunction(JXValue *value);

JXCORE_EXTERN(bool)
JX_IsError(JXValue *value);

JXCORE_EXTERN(bool)
JX_IsInt32(JXValue *value);

JXCORE_EXTERN(bool)
JX_IsDouble(JXValue *value);

JXCORE_EXTERN(bool)
JX_IsBoolean(JXValue *value);

JXCORE_EXTERN(bool)
JX_IsString(JXValue *value);

JXCORE_EXTERN(bool)
JX_IsJSON(JXValue *value);

JXCORE_EXTERN(bool)
JX_IsBuffer(JXValue *value);

JXCORE_EXTERN(bool)
JX_IsUndefined(JXValue *value);

JXCORE_EXTERN(bool)
JX_IsNull(JXValue *value);

JXCORE_EXTERN(bool)
JX_IsNullOrUndefined(JXValue *value);

JXCORE_EXTERN(bool)
JX_IsObject(JXValue *value);

JXCORE_EXTERN(int32_t)
JX_GetInt32(JXValue *value);

JXCORE_EXTERN(double)
JX_GetDouble(JXValue *value);

JXCORE_EXTERN(bool)
JX_GetBoolean(JXValue *value);

// for String, JSON, Error
// call free on return value when you are done with it
JXCORE_EXTERN(char *)
JX_GetString(JXValue *value);

JXCORE_EXTERN(int32_t)
JX_GetDataLength(JXValue *value);

// for Buffer, it returns a direct pointer to the underlying data. no copying
// involved
// don't hold to it longer than necessary, it may be gc'd away
JXCORE_EXTERN(char *)
JX_GetBuffer(JXValue *value);

JXCORE_EXTERN(void)
JX_SetInt32(JXValue *value, const int32_t val);

JXCORE_EXTERN(void)
JX_SetDouble(JXValue *value, const double val);

JXCORE_EXTERN(void)
JX_SetBoolean(JXValue *value, const bool val);

#ifdef __cplusplus
JXCORE_EXTERN(void)
JX_SetString(JXValue *value, const char *val, const int32_t length = 0);
#else
JXCORE_EXTERN(void)
JX_SetString(JXValue *value, const char *val, const int32_t length);
#endif

#ifdef __cplusplus
JXCORE_EXTERN(void)
JX_SetUCString(JXValue *value, const uint16_t *val, const int32_t length = 0);
#else
JXCORE_EXTERN(void)
JX_SetUCString(JXValue *value, const uint16_t *val, const int32_t length);
#endif

#ifdef __cplusplus
JXCORE_EXTERN(void)
JX_SetJSON(JXValue *value, const char *val, const int32_t length = 0);
#else
JXCORE_EXTERN(void)
JX_SetJSON(JXValue *value, const char *val, const int32_t length);
#endif

#ifdef __cplusplus
JXCORE_EXTERN(void)
JX_SetError(JXValue *value, const char *val, const int32_t length = 0);
#else
JXCORE_EXTERN(void)
JX_SetError(JXValue *value, const char *val, const int32_t length);
#endif

#ifdef __cplusplus
JXCORE_EXTERN(void)
JX_SetBuffer(JXValue *value, const char *val, const int32_t length = 0);
#else
JXCORE_EXTERN(void)
JX_SetBuffer(JXValue *value, const char *val, const int32_t length);
#endif

JXCORE_EXTERN(void)
JX_SetUndefined(JXValue *value);

JXCORE_EXTERN(void)
JX_SetNull(JXValue *value);

JXCORE_EXTERN(void)
JX_SetObject(JXValue *host, JXValue *val);

// do not use this for method parameters, jxcore cleanups them
// Beware JX_Evaluate, this methods needs to be called to cleanup JXResult
JXCORE_EXTERN(void)
JX_Free(JXValue *value);

JXCORE_EXTERN(bool)
JX_New(JXValue *value);

JXCORE_EXTERN(bool)
JX_CreateEmptyObject(JXValue *value);

JXCORE_EXTERN(bool)
JX_CreateArrayObject(JXValue *value);

JXCORE_EXTERN(void)
JX_SetNamedProperty(JXValue *object, const char *name, JXValue *prop);

JXCORE_EXTERN(void)
JX_SetIndexedProperty(JXValue *object, const unsigned index, JXValue *prop);

JXCORE_EXTERN(void)
JX_GetNamedProperty(JXValue *object, const char *name, JXValue *out);

JXCORE_EXTERN(void)
JX_GetIndexedProperty(JXValue *object, const int index, JXValue *out);

// if you have a JXValue around, this method brings threadId much faster
JXCORE_EXTERN(int)
JX_GetThreadIdByValue(JXValue *value);

JXCORE_EXTERN(void)
JX_GetGlobalObject(JXValue *out);

JXCORE_EXTERN(void)
JX_GetProcessObject(JXValue *out);

JXCORE_EXTERN(void)
JX_WrapObject(JXValue *object, void *ptr);

JXCORE_EXTERN(void *)
JX_UnwrapObject(JXValue *object);

#ifndef _JXCORE_EXT_ABI_CHECK
#define _JXCORE_EXT_ABI_CHECK(expr)			extern void jx___ABI_check__static_assert(int j____argv[((expr)?1:-1)])
#endif /* _JXCORE_EXT_ABI_CHECK */

#if    !defined(_JXCORE_OFFSETOF) && defined(__GNUC__)
#define _JXCORE_OFFSETOF(s,m)				__builtin_offsetof (s, m)
#elif  !defined(_JXCORE_OFFSETOF)
#define _JXCORE_OFFSETOF(s,m)				((uintptr_t)&(((s *)0)->m))
#endif /* _JXCORE_OFFSETOF */

_JXCORE_EXT_ABI_CHECK(sizeof(JXValue) == 4 * sizeof(void*));
_JXCORE_EXT_ABI_CHECK(0 * sizeof(void*) + 0 == _JXCORE_OFFSETOF(JXValue, com_));
_JXCORE_EXT_ABI_CHECK(1 * sizeof(void*) + 0 == _JXCORE_OFFSETOF(JXValue, data_));
_JXCORE_EXT_ABI_CHECK(2 * sizeof(void*) + 0 == _JXCORE_OFFSETOF(JXValue, size_));
_JXCORE_EXT_ABI_CHECK(3 * sizeof(void*) + 0 == _JXCORE_OFFSETOF(JXValue, persistent_));
_JXCORE_EXT_ABI_CHECK(3 * sizeof(void*) + 1 == _JXCORE_OFFSETOF(JXValue, was_stored_));
_JXCORE_EXT_ABI_CHECK(3 * sizeof(void*) + 2 == _JXCORE_OFFSETOF(JXValue, type_));

#ifdef __cplusplus
}
#endif

#endif  // SRC_PUBLIC_JX_RESULT_H

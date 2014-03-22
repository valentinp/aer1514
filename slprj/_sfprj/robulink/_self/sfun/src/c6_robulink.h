#ifndef __c6_robulink_h__
#define __c6_robulink_h__

/* Include files */
#include "sfc_sf.h"
#include "sfc_mex.h"
#include "rtwtypes.h"

/* Type Definitions */
#ifndef typedef_SFc6_robulinkInstanceStruct
#define typedef_SFc6_robulinkInstanceStruct

typedef struct {
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  int32_T c6_sfEvent;
  boolean_T c6_isStable;
  boolean_T c6_doneDoubleBufferReInit;
  uint8_T c6_is_active_c6_robulink;
  real_T *c6_theta_address;
  int32_T c6_theta_index;
  real_T *c6_x_address;
  int32_T c6_x_index;
  real_T *c6_y_address;
  int32_T c6_y_index;
} SFc6_robulinkInstanceStruct;

#endif                                 /*typedef_SFc6_robulinkInstanceStruct*/

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
extern const mxArray *sf_c6_robulink_get_eml_resolved_functions_info(void);

/* Function Definitions */
extern void sf_c6_robulink_get_check_sum(mxArray *plhs[]);
extern void c6_robulink_method_dispatcher(SimStruct *S, int_T method, void *data);

#endif

/* Include files */

#include <stddef.h>
#include "blas.h"
#include "robulink_sfun.h"
#include "c6_robulink.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "robulink_sfun_debug_macros.h"
#define _SF_MEX_LISTEN_FOR_CTRL_C(S)   sf_mex_listen_for_ctrl_c(sfGlobalDebugInstanceStruct,S);

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)

/* Variable Declarations */

/* Variable Definitions */
static const char * c6_debug_family_names[9] = { "nargin", "nargout",
  "resetFlag", "newX", "newY", "newTheta", "x", "y", "theta" };

/* Function Declarations */
static void initialize_c6_robulink(SFc6_robulinkInstanceStruct *chartInstance);
static void initialize_params_c6_robulink(SFc6_robulinkInstanceStruct
  *chartInstance);
static void enable_c6_robulink(SFc6_robulinkInstanceStruct *chartInstance);
static void disable_c6_robulink(SFc6_robulinkInstanceStruct *chartInstance);
static void c6_update_debugger_state_c6_robulink(SFc6_robulinkInstanceStruct
  *chartInstance);
static const mxArray *get_sim_state_c6_robulink(SFc6_robulinkInstanceStruct
  *chartInstance);
static void set_sim_state_c6_robulink(SFc6_robulinkInstanceStruct *chartInstance,
  const mxArray *c6_st);
static void finalize_c6_robulink(SFc6_robulinkInstanceStruct *chartInstance);
static void sf_c6_robulink(SFc6_robulinkInstanceStruct *chartInstance);
static void initSimStructsc6_robulink(SFc6_robulinkInstanceStruct *chartInstance);
static void registerMessagesc6_robulink(SFc6_robulinkInstanceStruct
  *chartInstance);
static void init_script_number_translation(uint32_T c6_machineNumber, uint32_T
  c6_chartNumber);
static const mxArray *c6_sf_marshallOut(void *chartInstanceVoid, void *c6_inData);
static real_T c6_emlrt_marshallIn(SFc6_robulinkInstanceStruct *chartInstance,
  const mxArray *c6_u, const emlrtMsgIdentifier *c6_parentId);
static void c6_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c6_mxArrayInData, const char_T *c6_varName, void *c6_outData);
static const mxArray *c6_b_sf_marshallOut(void *chartInstanceVoid, void
  *c6_inData);
static int32_T c6_b_emlrt_marshallIn(SFc6_robulinkInstanceStruct *chartInstance,
  const mxArray *c6_u, const emlrtMsgIdentifier *c6_parentId);
static void c6_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c6_mxArrayInData, const char_T *c6_varName, void *c6_outData);
static uint8_T c6_c_emlrt_marshallIn(SFc6_robulinkInstanceStruct *chartInstance,
  const mxArray *c6_b_is_active_c6_robulink, const char_T *c6_identifier);
static uint8_T c6_d_emlrt_marshallIn(SFc6_robulinkInstanceStruct *chartInstance,
  const mxArray *c6_u, const emlrtMsgIdentifier *c6_parentId);
static real_T c6_get_theta(SFc6_robulinkInstanceStruct *chartInstance, uint32_T
  c6_b);
static void c6_set_theta(SFc6_robulinkInstanceStruct *chartInstance, uint32_T
  c6_b, real_T c6_c);
static real_T *c6_access_theta(SFc6_robulinkInstanceStruct *chartInstance,
  uint32_T c6_b);
static real_T c6_get_x(SFc6_robulinkInstanceStruct *chartInstance, uint32_T c6_b);
static void c6_set_x(SFc6_robulinkInstanceStruct *chartInstance, uint32_T c6_b,
                     real_T c6_c);
static real_T *c6_access_x(SFc6_robulinkInstanceStruct *chartInstance, uint32_T
  c6_b);
static real_T c6_get_y(SFc6_robulinkInstanceStruct *chartInstance, uint32_T c6_b);
static void c6_set_y(SFc6_robulinkInstanceStruct *chartInstance, uint32_T c6_b,
                     real_T c6_c);
static real_T *c6_access_y(SFc6_robulinkInstanceStruct *chartInstance, uint32_T
  c6_b);
static void init_dsm_address_info(SFc6_robulinkInstanceStruct *chartInstance);

/* Function Definitions */
static void initialize_c6_robulink(SFc6_robulinkInstanceStruct *chartInstance)
{
  chartInstance->c6_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c6_is_active_c6_robulink = 0U;
}

static void initialize_params_c6_robulink(SFc6_robulinkInstanceStruct
  *chartInstance)
{
}

static void enable_c6_robulink(SFc6_robulinkInstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c6_robulink(SFc6_robulinkInstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void c6_update_debugger_state_c6_robulink(SFc6_robulinkInstanceStruct
  *chartInstance)
{
}

static const mxArray *get_sim_state_c6_robulink(SFc6_robulinkInstanceStruct
  *chartInstance)
{
  const mxArray *c6_st;
  const mxArray *c6_y = NULL;
  uint8_T c6_hoistedGlobal;
  uint8_T c6_u;
  const mxArray *c6_b_y = NULL;
  c6_st = NULL;
  c6_st = NULL;
  c6_y = NULL;
  sf_mex_assign(&c6_y, sf_mex_createcellarray(1), FALSE);
  c6_hoistedGlobal = chartInstance->c6_is_active_c6_robulink;
  c6_u = c6_hoistedGlobal;
  c6_b_y = NULL;
  sf_mex_assign(&c6_b_y, sf_mex_create("y", &c6_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c6_y, 0, c6_b_y);
  sf_mex_assign(&c6_st, c6_y, FALSE);
  return c6_st;
}

static void set_sim_state_c6_robulink(SFc6_robulinkInstanceStruct *chartInstance,
  const mxArray *c6_st)
{
  const mxArray *c6_u;
  chartInstance->c6_doneDoubleBufferReInit = TRUE;
  c6_u = sf_mex_dup(c6_st);
  chartInstance->c6_is_active_c6_robulink = c6_c_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c6_u, 0)), "is_active_c6_robulink");
  sf_mex_destroy(&c6_u);
  c6_update_debugger_state_c6_robulink(chartInstance);
  sf_mex_destroy(&c6_st);
}

static void finalize_c6_robulink(SFc6_robulinkInstanceStruct *chartInstance)
{
}

static void sf_c6_robulink(SFc6_robulinkInstanceStruct *chartInstance)
{
  real_T c6_hoistedGlobal;
  real_T c6_b_hoistedGlobal;
  real_T c6_c_hoistedGlobal;
  real_T c6_d_hoistedGlobal;
  real_T c6_resetFlag;
  real_T c6_newX;
  real_T c6_newY;
  real_T c6_newTheta;
  uint32_T c6_debug_family_var_map[9];
  real_T c6_nargin = 4.0;
  real_T c6_nargout = 0.0;
  real_T *c6_b_resetFlag;
  real_T *c6_b_newX;
  real_T *c6_b_newY;
  real_T *c6_b_newTheta;
  c6_b_newTheta = (real_T *)ssGetInputPortSignal(chartInstance->S, 3);
  c6_b_newY = (real_T *)ssGetInputPortSignal(chartInstance->S, 2);
  c6_b_newX = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
  c6_b_resetFlag = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 5U, chartInstance->c6_sfEvent);
  _SFD_DATA_RANGE_CHECK(*c6_b_resetFlag, 0U);
  _SFD_DATA_RANGE_CHECK(*c6_b_newX, 4U);
  _SFD_DATA_RANGE_CHECK(*c6_b_newY, 5U);
  _SFD_DATA_RANGE_CHECK(*c6_b_newTheta, 6U);
  chartInstance->c6_sfEvent = CALL_EVENT;
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 5U, chartInstance->c6_sfEvent);
  c6_hoistedGlobal = *c6_b_resetFlag;
  c6_b_hoistedGlobal = *c6_b_newX;
  c6_c_hoistedGlobal = *c6_b_newY;
  c6_d_hoistedGlobal = *c6_b_newTheta;
  c6_resetFlag = c6_hoistedGlobal;
  c6_newX = c6_b_hoistedGlobal;
  c6_newY = c6_c_hoistedGlobal;
  c6_newTheta = c6_d_hoistedGlobal;
  _SFD_SYMBOL_SCOPE_PUSH_EML(0U, 9U, 9U, c6_debug_family_names,
    c6_debug_family_var_map);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c6_nargin, 0U, c6_sf_marshallOut,
    c6_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c6_nargout, 1U, c6_sf_marshallOut,
    c6_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c6_resetFlag, 2U, c6_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c6_newX, 3U, c6_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c6_newY, 4U, c6_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c6_newTheta, 5U, c6_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(chartInstance->c6_x_address, 6U,
    c6_sf_marshallOut, c6_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(chartInstance->c6_y_address, 7U,
    c6_sf_marshallOut, c6_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(chartInstance->c6_theta_address, 8U,
    c6_sf_marshallOut, c6_sf_marshallIn);
  CV_EML_FCN(0, 0);
  _SFD_EML_CALL(0U, chartInstance->c6_sfEvent, 2);
  _SFD_EML_CALL(0U, chartInstance->c6_sfEvent, 3);
  _SFD_EML_CALL(0U, chartInstance->c6_sfEvent, 4);
  _SFD_EML_CALL(0U, chartInstance->c6_sfEvent, 6);
  if (CV_EML_IF(0, 1, 0, c6_resetFlag == 1.0)) {
    _SFD_EML_CALL(0U, chartInstance->c6_sfEvent, 7);
    c6_set_x(chartInstance, 0, c6_newX);
    ssUpdateDataStoreLog(chartInstance->S, 1);
    _SFD_EML_CALL(0U, chartInstance->c6_sfEvent, 8);
    c6_set_y(chartInstance, 0, c6_newY);
    ssUpdateDataStoreLog(chartInstance->S, 2);
    _SFD_EML_CALL(0U, chartInstance->c6_sfEvent, 9);
    c6_set_theta(chartInstance, 0, c6_newTheta);
    ssUpdateDataStoreLog(chartInstance->S, 0);
  }

  _SFD_EML_CALL(0U, chartInstance->c6_sfEvent, -9);
  _SFD_SYMBOL_SCOPE_POP();
  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 5U, chartInstance->c6_sfEvent);
  _SFD_CHECK_FOR_STATE_INCONSISTENCY(_robulinkMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void initSimStructsc6_robulink(SFc6_robulinkInstanceStruct *chartInstance)
{
}

static void registerMessagesc6_robulink(SFc6_robulinkInstanceStruct
  *chartInstance)
{
}

static void init_script_number_translation(uint32_T c6_machineNumber, uint32_T
  c6_chartNumber)
{
}

static const mxArray *c6_sf_marshallOut(void *chartInstanceVoid, void *c6_inData)
{
  const mxArray *c6_mxArrayOutData = NULL;
  real_T c6_u;
  const mxArray *c6_y = NULL;
  SFc6_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc6_robulinkInstanceStruct *)chartInstanceVoid;
  c6_mxArrayOutData = NULL;
  c6_u = *(real_T *)c6_inData;
  c6_y = NULL;
  sf_mex_assign(&c6_y, sf_mex_create("y", &c6_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c6_mxArrayOutData, c6_y, FALSE);
  return c6_mxArrayOutData;
}

static real_T c6_emlrt_marshallIn(SFc6_robulinkInstanceStruct *chartInstance,
  const mxArray *c6_u, const emlrtMsgIdentifier *c6_parentId)
{
  real_T c6_y;
  real_T c6_d0;
  sf_mex_import(c6_parentId, sf_mex_dup(c6_u), &c6_d0, 1, 0, 0U, 0, 0U, 0);
  c6_y = c6_d0;
  sf_mex_destroy(&c6_u);
  return c6_y;
}

static void c6_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c6_mxArrayInData, const char_T *c6_varName, void *c6_outData)
{
  const mxArray *c6_theta;
  const char_T *c6_identifier;
  emlrtMsgIdentifier c6_thisId;
  real_T c6_y;
  SFc6_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc6_robulinkInstanceStruct *)chartInstanceVoid;
  c6_theta = sf_mex_dup(c6_mxArrayInData);
  c6_identifier = c6_varName;
  c6_thisId.fIdentifier = c6_identifier;
  c6_thisId.fParent = NULL;
  c6_y = c6_emlrt_marshallIn(chartInstance, sf_mex_dup(c6_theta), &c6_thisId);
  sf_mex_destroy(&c6_theta);
  *(real_T *)c6_outData = c6_y;
  sf_mex_destroy(&c6_mxArrayInData);
}

const mxArray *sf_c6_robulink_get_eml_resolved_functions_info(void)
{
  const mxArray *c6_nameCaptureInfo = NULL;
  c6_nameCaptureInfo = NULL;
  sf_mex_assign(&c6_nameCaptureInfo, sf_mex_create("nameCaptureInfo", NULL, 0,
    0U, 1U, 0U, 2, 0, 1), FALSE);
  return c6_nameCaptureInfo;
}

static const mxArray *c6_b_sf_marshallOut(void *chartInstanceVoid, void
  *c6_inData)
{
  const mxArray *c6_mxArrayOutData = NULL;
  int32_T c6_u;
  const mxArray *c6_y = NULL;
  SFc6_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc6_robulinkInstanceStruct *)chartInstanceVoid;
  c6_mxArrayOutData = NULL;
  c6_u = *(int32_T *)c6_inData;
  c6_y = NULL;
  sf_mex_assign(&c6_y, sf_mex_create("y", &c6_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c6_mxArrayOutData, c6_y, FALSE);
  return c6_mxArrayOutData;
}

static int32_T c6_b_emlrt_marshallIn(SFc6_robulinkInstanceStruct *chartInstance,
  const mxArray *c6_u, const emlrtMsgIdentifier *c6_parentId)
{
  int32_T c6_y;
  int32_T c6_i0;
  sf_mex_import(c6_parentId, sf_mex_dup(c6_u), &c6_i0, 1, 6, 0U, 0, 0U, 0);
  c6_y = c6_i0;
  sf_mex_destroy(&c6_u);
  return c6_y;
}

static void c6_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c6_mxArrayInData, const char_T *c6_varName, void *c6_outData)
{
  const mxArray *c6_b_sfEvent;
  const char_T *c6_identifier;
  emlrtMsgIdentifier c6_thisId;
  int32_T c6_y;
  SFc6_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc6_robulinkInstanceStruct *)chartInstanceVoid;
  c6_b_sfEvent = sf_mex_dup(c6_mxArrayInData);
  c6_identifier = c6_varName;
  c6_thisId.fIdentifier = c6_identifier;
  c6_thisId.fParent = NULL;
  c6_y = c6_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c6_b_sfEvent),
    &c6_thisId);
  sf_mex_destroy(&c6_b_sfEvent);
  *(int32_T *)c6_outData = c6_y;
  sf_mex_destroy(&c6_mxArrayInData);
}

static uint8_T c6_c_emlrt_marshallIn(SFc6_robulinkInstanceStruct *chartInstance,
  const mxArray *c6_b_is_active_c6_robulink, const char_T *c6_identifier)
{
  uint8_T c6_y;
  emlrtMsgIdentifier c6_thisId;
  c6_thisId.fIdentifier = c6_identifier;
  c6_thisId.fParent = NULL;
  c6_y = c6_d_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c6_b_is_active_c6_robulink), &c6_thisId);
  sf_mex_destroy(&c6_b_is_active_c6_robulink);
  return c6_y;
}

static uint8_T c6_d_emlrt_marshallIn(SFc6_robulinkInstanceStruct *chartInstance,
  const mxArray *c6_u, const emlrtMsgIdentifier *c6_parentId)
{
  uint8_T c6_y;
  uint8_T c6_u0;
  sf_mex_import(c6_parentId, sf_mex_dup(c6_u), &c6_u0, 1, 3, 0U, 0, 0U, 0);
  c6_y = c6_u0;
  sf_mex_destroy(&c6_u);
  return c6_y;
}

static real_T c6_get_theta(SFc6_robulinkInstanceStruct *chartInstance, uint32_T
  c6_b)
{
  ssReadFromDataStoreElement(chartInstance->S, 0, NULL, c6_b);
  if (chartInstance->c6_theta_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'theta\' (#69) in the initialization routine of the chart.\n");
  }

  return *chartInstance->c6_theta_address;
}

static void c6_set_theta(SFc6_robulinkInstanceStruct *chartInstance, uint32_T
  c6_b, real_T c6_c)
{
  ssWriteToDataStoreElement(chartInstance->S, 0, NULL, c6_b);
  if (chartInstance->c6_theta_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'theta\' (#69) in the initialization routine of the chart.\n");
  }

  *chartInstance->c6_theta_address = c6_c;
}

static real_T *c6_access_theta(SFc6_robulinkInstanceStruct *chartInstance,
  uint32_T c6_b)
{
  real_T *c6_c;
  ssReadFromDataStore(chartInstance->S, 0, NULL);
  if (chartInstance->c6_theta_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'theta\' (#69) in the initialization routine of the chart.\n");
  }

  c6_c = chartInstance->c6_theta_address;
  if (c6_b == 0) {
    ssWriteToDataStore(chartInstance->S, 0, NULL);
  }

  return c6_c;
}

static real_T c6_get_x(SFc6_robulinkInstanceStruct *chartInstance, uint32_T c6_b)
{
  ssReadFromDataStoreElement(chartInstance->S, 1, NULL, c6_b);
  if (chartInstance->c6_x_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'x\' (#67) in the initialization routine of the chart.\n");
  }

  return *chartInstance->c6_x_address;
}

static void c6_set_x(SFc6_robulinkInstanceStruct *chartInstance, uint32_T c6_b,
                     real_T c6_c)
{
  ssWriteToDataStoreElement(chartInstance->S, 1, NULL, c6_b);
  if (chartInstance->c6_x_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'x\' (#67) in the initialization routine of the chart.\n");
  }

  *chartInstance->c6_x_address = c6_c;
}

static real_T *c6_access_x(SFc6_robulinkInstanceStruct *chartInstance, uint32_T
  c6_b)
{
  real_T *c6_c;
  ssReadFromDataStore(chartInstance->S, 1, NULL);
  if (chartInstance->c6_x_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'x\' (#67) in the initialization routine of the chart.\n");
  }

  c6_c = chartInstance->c6_x_address;
  if (c6_b == 0) {
    ssWriteToDataStore(chartInstance->S, 1, NULL);
  }

  return c6_c;
}

static real_T c6_get_y(SFc6_robulinkInstanceStruct *chartInstance, uint32_T c6_b)
{
  ssReadFromDataStoreElement(chartInstance->S, 2, NULL, c6_b);
  if (chartInstance->c6_y_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'y\' (#68) in the initialization routine of the chart.\n");
  }

  return *chartInstance->c6_y_address;
}

static void c6_set_y(SFc6_robulinkInstanceStruct *chartInstance, uint32_T c6_b,
                     real_T c6_c)
{
  ssWriteToDataStoreElement(chartInstance->S, 2, NULL, c6_b);
  if (chartInstance->c6_y_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'y\' (#68) in the initialization routine of the chart.\n");
  }

  *chartInstance->c6_y_address = c6_c;
}

static real_T *c6_access_y(SFc6_robulinkInstanceStruct *chartInstance, uint32_T
  c6_b)
{
  real_T *c6_c;
  ssReadFromDataStore(chartInstance->S, 2, NULL);
  if (chartInstance->c6_y_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'y\' (#68) in the initialization routine of the chart.\n");
  }

  c6_c = chartInstance->c6_y_address;
  if (c6_b == 0) {
    ssWriteToDataStore(chartInstance->S, 2, NULL);
  }

  return c6_c;
}

static void init_dsm_address_info(SFc6_robulinkInstanceStruct *chartInstance)
{
  ssGetSFcnDataStoreNameAddrIdx(chartInstance->S, "theta", (void **)
    &chartInstance->c6_theta_address, &chartInstance->c6_theta_index);
  ssGetSFcnDataStoreNameAddrIdx(chartInstance->S, "x", (void **)
    &chartInstance->c6_x_address, &chartInstance->c6_x_index);
  ssGetSFcnDataStoreNameAddrIdx(chartInstance->S, "y", (void **)
    &chartInstance->c6_y_address, &chartInstance->c6_y_index);
}

/* SFunction Glue Code */
#ifdef utFree
#undef utFree
#endif

#ifdef utMalloc
#undef utMalloc
#endif

#ifdef __cplusplus

extern "C" void *utMalloc(size_t size);
extern "C" void utFree(void*);

#else

extern void *utMalloc(size_t size);
extern void utFree(void*);

#endif

void sf_c6_robulink_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(2554996580U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(1125390499U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(3606763822U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(2281318703U);
}

mxArray *sf_c6_robulink_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("KRWXWTFTiMXbDWxchQoSdF");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,4,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,1,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,1,"type",mxType);
    }

    mxSetField(mxData,1,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,2,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,2,"type",mxType);
    }

    mxSetField(mxData,2,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,3,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,3,"type",mxType);
    }

    mxSetField(mxData,3,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"inputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"parameters",mxCreateDoubleMatrix(0,0,
                mxREAL));
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"outputs",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"locals",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  return(mxAutoinheritanceInfo);
}

mxArray *sf_c6_robulink_third_party_uses_info(void)
{
  mxArray * mxcell3p = mxCreateCellMatrix(1,0);
  return(mxcell3p);
}

static const mxArray *sf_get_sim_state_info_c6_robulink(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S'type','srcId','name','auxInfo'{{M[8],M[0],T\"is_active_c6_robulink\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 1, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c6_robulink_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc6_robulinkInstanceStruct *chartInstance;
    chartInstance = (SFc6_robulinkInstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (sfGlobalDebugInstanceStruct,
           _robulinkMachineNumber_,
           6,
           1,
           1,
           7,
           0,
           0,
           0,
           0,
           0,
           &(chartInstance->chartNumber),
           &(chartInstance->instanceNumber),
           ssGetPath(S),
           (void *)S);
        if (chartAlreadyPresent==0) {
          /* this is the first instance */
          init_script_number_translation(_robulinkMachineNumber_,
            chartInstance->chartNumber);
          sf_debug_set_chart_disable_implicit_casting
            (sfGlobalDebugInstanceStruct,_robulinkMachineNumber_,
             chartInstance->chartNumber,1);
          sf_debug_set_chart_event_thresholds(sfGlobalDebugInstanceStruct,
            _robulinkMachineNumber_,
            chartInstance->chartNumber,
            0,
            0,
            0);
          _SFD_SET_DATA_PROPS(0,1,1,0,"resetFlag");
          _SFD_SET_DATA_PROPS(1,11,0,0,"x");
          _SFD_SET_DATA_PROPS(2,11,0,0,"y");
          _SFD_SET_DATA_PROPS(3,11,0,0,"theta");
          _SFD_SET_DATA_PROPS(4,1,1,0,"newX");
          _SFD_SET_DATA_PROPS(5,1,1,0,"newY");
          _SFD_SET_DATA_PROPS(6,1,1,0,"newTheta");
          _SFD_STATE_INFO(0,0,2);
          _SFD_CH_SUBSTATE_COUNT(0);
          _SFD_CH_SUBSTATE_DECOMP(0);
        }

        _SFD_CV_INIT_CHART(0,0,0,0);

        {
          _SFD_CV_INIT_STATE(0,0,0,0,0,0,NULL,NULL);
        }

        _SFD_CV_INIT_TRANS(0,0,NULL,NULL,0,NULL);

        /* Initialization of MATLAB Function Model Coverage */
        _SFD_CV_INIT_EML(0,1,1,1,0,0,0,0,0,0,0);
        _SFD_CV_INIT_EML_FCN(0,0,"eML_blk_kernel",0,-1,202);
        _SFD_CV_INIT_EML_IF(0,1,0,109,127,-1,197);
        _SFD_TRANS_COV_WTS(0,0,0,1,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              1,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c6_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(1,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c6_sf_marshallOut,(MexInFcnForType)c6_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(2,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c6_sf_marshallOut,(MexInFcnForType)c6_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(3,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c6_sf_marshallOut,(MexInFcnForType)c6_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(4,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c6_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(5,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c6_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(6,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c6_sf_marshallOut,(MexInFcnForType)NULL);

        {
          real_T *c6_resetFlag;
          real_T *c6_newX;
          real_T *c6_newY;
          real_T *c6_newTheta;
          c6_newTheta = (real_T *)ssGetInputPortSignal(chartInstance->S, 3);
          c6_newY = (real_T *)ssGetInputPortSignal(chartInstance->S, 2);
          c6_newX = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
          c6_resetFlag = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
          _SFD_SET_DATA_VALUE_PTR(0U, c6_resetFlag);
          _SFD_SET_DATA_VALUE_PTR(1U, chartInstance->c6_x_address);
          _SFD_SET_DATA_VALUE_PTR(2U, chartInstance->c6_y_address);
          _SFD_SET_DATA_VALUE_PTR(3U, chartInstance->c6_theta_address);
          _SFD_SET_DATA_VALUE_PTR(4U, c6_newX);
          _SFD_SET_DATA_VALUE_PTR(5U, c6_newY);
          _SFD_SET_DATA_VALUE_PTR(6U, c6_newTheta);
        }
      }
    } else {
      sf_debug_reset_current_state_configuration(sfGlobalDebugInstanceStruct,
        _robulinkMachineNumber_,chartInstance->chartNumber,
        chartInstance->instanceNumber);
    }
  }
}

static const char* sf_get_instance_specialization(void)
{
  return "7E1SLJYwCxH6J4woDb8ah";
}

static void sf_opaque_initialize_c6_robulink(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc6_robulinkInstanceStruct*) chartInstanceVar)
    ->S,0);
  initialize_params_c6_robulink((SFc6_robulinkInstanceStruct*) chartInstanceVar);
  initialize_c6_robulink((SFc6_robulinkInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_enable_c6_robulink(void *chartInstanceVar)
{
  enable_c6_robulink((SFc6_robulinkInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_disable_c6_robulink(void *chartInstanceVar)
{
  disable_c6_robulink((SFc6_robulinkInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_gateway_c6_robulink(void *chartInstanceVar)
{
  sf_c6_robulink((SFc6_robulinkInstanceStruct*) chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c6_robulink(SimStruct* S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c6_robulink((SFc6_robulinkInstanceStruct*)
    chartInfo->chartInstance);         /* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c6_robulink();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_raw2high'.\n");
  }

  return plhs[0];
}

extern void sf_internal_set_sim_state_c6_robulink(SimStruct* S, const mxArray
  *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c6_robulink();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c6_robulink((SFc6_robulinkInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c6_robulink(SimStruct* S)
{
  return sf_internal_get_sim_state_c6_robulink(S);
}

static void sf_opaque_set_sim_state_c6_robulink(SimStruct* S, const mxArray *st)
{
  sf_internal_set_sim_state_c6_robulink(S, st);
}

static void sf_opaque_terminate_c6_robulink(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc6_robulinkInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
      unload_robulink_optimization_info();
    }

    finalize_c6_robulink((SFc6_robulinkInstanceStruct*) chartInstanceVar);
    utFree((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc6_robulink((SFc6_robulinkInstanceStruct*) chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c6_robulink(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c6_robulink((SFc6_robulinkInstanceStruct*)
      (((ChartInfoStruct *)ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c6_robulink(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_robulink_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      6);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,6,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,6,
      "gatewayCannotBeInlinedMultipleTimes"));
    sf_update_buildInfo(S,sf_get_instance_specialization(),infoStruct,6);
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 1, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 2, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 3, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,6,4);
    }

    {
      unsigned int outPortIdx;
      for (outPortIdx=1; outPortIdx<=0; ++outPortIdx) {
        ssSetOutputPortOptimizeInIR(S, outPortIdx, 1U);
      }
    }

    {
      unsigned int inPortIdx;
      for (inPortIdx=0; inPortIdx < 4; ++inPortIdx) {
        ssSetInputPortOptimizeInIR(S, inPortIdx, 1U);
      }
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,6);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(1032595104U));
  ssSetChecksum1(S,(867378072U));
  ssSetChecksum2(S,(3642619363U));
  ssSetChecksum3(S,(1668617627U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
  ssSupportsMultipleExecInstances(S,0);
}

static void mdlRTW_c6_robulink(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Embedded MATLAB");
  }
}

static void mdlStart_c6_robulink(SimStruct *S)
{
  SFc6_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc6_robulinkInstanceStruct *)utMalloc(sizeof
    (SFc6_robulinkInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc6_robulinkInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 1;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway = sf_opaque_gateway_c6_robulink;
  chartInstance->chartInfo.initializeChart = sf_opaque_initialize_c6_robulink;
  chartInstance->chartInfo.terminateChart = sf_opaque_terminate_c6_robulink;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c6_robulink;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c6_robulink;
  chartInstance->chartInfo.getSimState = sf_opaque_get_sim_state_c6_robulink;
  chartInstance->chartInfo.setSimState = sf_opaque_set_sim_state_c6_robulink;
  chartInstance->chartInfo.getSimStateInfo = sf_get_sim_state_info_c6_robulink;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c6_robulink;
  chartInstance->chartInfo.mdlStart = mdlStart_c6_robulink;
  chartInstance->chartInfo.mdlSetWorkWidths = mdlSetWorkWidths_c6_robulink;
  chartInstance->chartInfo.extModeExec = NULL;
  chartInstance->chartInfo.restoreLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.restoreBeforeLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.storeCurrentConfiguration = NULL;
  chartInstance->S = S;
  ssSetUserData(S,(void *)(&(chartInstance->chartInfo)));/* register the chart instance with simstruct */
  init_dsm_address_info(chartInstance);
  if (!sim_mode_is_rtw_gen(S)) {
  }

  sf_opaque_init_subchart_simstructs(chartInstance->chartInfo.chartInstance);
  chart_debug_initialization(S,1);
}

void c6_robulink_method_dispatcher(SimStruct *S, int_T method, void *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c6_robulink(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c6_robulink(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c6_robulink(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c6_robulink_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}

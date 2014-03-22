/* Include files */

#include <stddef.h>
#include "blas.h"
#include "robulink_sfun.h"
#include "c5_robulink.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "robulink_sfun_debug_macros.h"
#define _SF_MEX_LISTEN_FOR_CTRL_C(S)   sf_mex_listen_for_ctrl_c(sfGlobalDebugInstanceStruct,S);

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)

/* Variable Declarations */

/* Variable Definitions */
static const char * c5_debug_family_names[10] = { "FILTER_SIZE",
  "SAMPLE_THRESHOLD", "avg", "nargin", "nargout", "u", "isOverSample", "i",
  "buf", "bufSum" };

/* Function Declarations */
static void initialize_c5_robulink(SFc5_robulinkInstanceStruct *chartInstance);
static void initialize_params_c5_robulink(SFc5_robulinkInstanceStruct
  *chartInstance);
static void enable_c5_robulink(SFc5_robulinkInstanceStruct *chartInstance);
static void disable_c5_robulink(SFc5_robulinkInstanceStruct *chartInstance);
static void c5_update_debugger_state_c5_robulink(SFc5_robulinkInstanceStruct
  *chartInstance);
static const mxArray *get_sim_state_c5_robulink(SFc5_robulinkInstanceStruct
  *chartInstance);
static void set_sim_state_c5_robulink(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_st);
static void finalize_c5_robulink(SFc5_robulinkInstanceStruct *chartInstance);
static void sf_c5_robulink(SFc5_robulinkInstanceStruct *chartInstance);
static void initSimStructsc5_robulink(SFc5_robulinkInstanceStruct *chartInstance);
static void registerMessagesc5_robulink(SFc5_robulinkInstanceStruct
  *chartInstance);
static void init_script_number_translation(uint32_T c5_machineNumber, uint32_T
  c5_chartNumber);
static const mxArray *c5_sf_marshallOut(void *chartInstanceVoid, void *c5_inData);
static real_T c5_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_b_bufSum, const char_T *c5_identifier);
static real_T c5_b_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId);
static void c5_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData);
static const mxArray *c5_b_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData);
static void c5_c_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_b_buf, const char_T *c5_identifier, real_T c5_y[10]);
static void c5_d_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId, real_T c5_y[10]);
static void c5_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData);
static const mxArray *c5_c_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData);
static real_T c5_e_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_b_i, const char_T *c5_identifier);
static real_T c5_f_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId);
static void c5_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData);
static const mxArray *c5_d_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData);
static boolean_T c5_g_emlrt_marshallIn(SFc5_robulinkInstanceStruct
  *chartInstance, const mxArray *c5_isOverSample, const char_T *c5_identifier);
static boolean_T c5_h_emlrt_marshallIn(SFc5_robulinkInstanceStruct
  *chartInstance, const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId);
static void c5_d_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData);
static const mxArray *c5_e_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData);
static const mxArray *c5_f_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData);
static real_T c5_i_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId);
static void c5_e_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData);
static const mxArray *c5_g_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData);
static int32_T c5_j_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId);
static void c5_f_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData);
static uint8_T c5_k_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_b_is_active_c5_robulink, const char_T *c5_identifier);
static uint8_T c5_l_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId);
static void init_dsm_address_info(SFc5_robulinkInstanceStruct *chartInstance);

/* Function Definitions */
static void initialize_c5_robulink(SFc5_robulinkInstanceStruct *chartInstance)
{
  chartInstance->c5_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c5_i_not_empty = FALSE;
  chartInstance->c5_buf_not_empty = FALSE;
  chartInstance->c5_bufSum_not_empty = FALSE;
  chartInstance->c5_is_active_c5_robulink = 0U;
}

static void initialize_params_c5_robulink(SFc5_robulinkInstanceStruct
  *chartInstance)
{
}

static void enable_c5_robulink(SFc5_robulinkInstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c5_robulink(SFc5_robulinkInstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void c5_update_debugger_state_c5_robulink(SFc5_robulinkInstanceStruct
  *chartInstance)
{
}

static const mxArray *get_sim_state_c5_robulink(SFc5_robulinkInstanceStruct
  *chartInstance)
{
  const mxArray *c5_st;
  const mxArray *c5_y = NULL;
  boolean_T c5_hoistedGlobal;
  boolean_T c5_u;
  const mxArray *c5_b_y = NULL;
  int32_T c5_i0;
  real_T c5_b_u[10];
  const mxArray *c5_c_y = NULL;
  real_T c5_b_hoistedGlobal;
  real_T c5_c_u;
  const mxArray *c5_d_y = NULL;
  real_T c5_c_hoistedGlobal;
  real_T c5_d_u;
  const mxArray *c5_e_y = NULL;
  uint8_T c5_d_hoistedGlobal;
  uint8_T c5_e_u;
  const mxArray *c5_f_y = NULL;
  boolean_T *c5_isOverSample;
  c5_isOverSample = (boolean_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c5_st = NULL;
  c5_st = NULL;
  c5_y = NULL;
  sf_mex_assign(&c5_y, sf_mex_createcellarray(5), FALSE);
  c5_hoistedGlobal = *c5_isOverSample;
  c5_u = c5_hoistedGlobal;
  c5_b_y = NULL;
  sf_mex_assign(&c5_b_y, sf_mex_create("y", &c5_u, 11, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c5_y, 0, c5_b_y);
  for (c5_i0 = 0; c5_i0 < 10; c5_i0++) {
    c5_b_u[c5_i0] = chartInstance->c5_buf[c5_i0];
  }

  c5_c_y = NULL;
  if (!chartInstance->c5_buf_not_empty) {
    sf_mex_assign(&c5_c_y, sf_mex_create("y", NULL, 0, 0U, 1U, 0U, 2, 0, 0),
                  FALSE);
  } else {
    sf_mex_assign(&c5_c_y, sf_mex_create("y", c5_b_u, 0, 0U, 1U, 0U, 2, 1, 10),
                  FALSE);
  }

  sf_mex_setcell(c5_y, 1, c5_c_y);
  c5_b_hoistedGlobal = chartInstance->c5_bufSum;
  c5_c_u = c5_b_hoistedGlobal;
  c5_d_y = NULL;
  if (!chartInstance->c5_bufSum_not_empty) {
    sf_mex_assign(&c5_d_y, sf_mex_create("y", NULL, 0, 0U, 1U, 0U, 2, 0, 0),
                  FALSE);
  } else {
    sf_mex_assign(&c5_d_y, sf_mex_create("y", &c5_c_u, 0, 0U, 0U, 0U, 0), FALSE);
  }

  sf_mex_setcell(c5_y, 2, c5_d_y);
  c5_c_hoistedGlobal = chartInstance->c5_i;
  c5_d_u = c5_c_hoistedGlobal;
  c5_e_y = NULL;
  if (!chartInstance->c5_i_not_empty) {
    sf_mex_assign(&c5_e_y, sf_mex_create("y", NULL, 0, 0U, 1U, 0U, 2, 0, 0),
                  FALSE);
  } else {
    sf_mex_assign(&c5_e_y, sf_mex_create("y", &c5_d_u, 0, 0U, 0U, 0U, 0), FALSE);
  }

  sf_mex_setcell(c5_y, 3, c5_e_y);
  c5_d_hoistedGlobal = chartInstance->c5_is_active_c5_robulink;
  c5_e_u = c5_d_hoistedGlobal;
  c5_f_y = NULL;
  sf_mex_assign(&c5_f_y, sf_mex_create("y", &c5_e_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c5_y, 4, c5_f_y);
  sf_mex_assign(&c5_st, c5_y, FALSE);
  return c5_st;
}

static void set_sim_state_c5_robulink(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_st)
{
  const mxArray *c5_u;
  real_T c5_dv0[10];
  int32_T c5_i1;
  boolean_T *c5_isOverSample;
  c5_isOverSample = (boolean_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  chartInstance->c5_doneDoubleBufferReInit = TRUE;
  c5_u = sf_mex_dup(c5_st);
  *c5_isOverSample = c5_g_emlrt_marshallIn(chartInstance, sf_mex_dup
    (sf_mex_getcell(c5_u, 0)), "isOverSample");
  c5_c_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c5_u, 1)),
                        "buf", c5_dv0);
  for (c5_i1 = 0; c5_i1 < 10; c5_i1++) {
    chartInstance->c5_buf[c5_i1] = c5_dv0[c5_i1];
  }

  chartInstance->c5_bufSum = c5_emlrt_marshallIn(chartInstance, sf_mex_dup
    (sf_mex_getcell(c5_u, 2)), "bufSum");
  chartInstance->c5_i = c5_e_emlrt_marshallIn(chartInstance, sf_mex_dup
    (sf_mex_getcell(c5_u, 3)), "i");
  chartInstance->c5_is_active_c5_robulink = c5_k_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c5_u, 4)), "is_active_c5_robulink");
  sf_mex_destroy(&c5_u);
  c5_update_debugger_state_c5_robulink(chartInstance);
  sf_mex_destroy(&c5_st);
}

static void finalize_c5_robulink(SFc5_robulinkInstanceStruct *chartInstance)
{
}

static void sf_c5_robulink(SFc5_robulinkInstanceStruct *chartInstance)
{
  uint16_T c5_hoistedGlobal;
  uint16_T c5_u;
  uint32_T c5_debug_family_var_map[10];
  real_T c5_FILTER_SIZE;
  real_T c5_SAMPLE_THRESHOLD;
  real_T c5_avg;
  real_T c5_nargin = 1.0;
  real_T c5_nargout = 1.0;
  boolean_T c5_isOverSample;
  int32_T c5_i2;
  real_T c5_b_hoistedGlobal;
  real_T c5_A;
  real_T c5_x;
  real_T c5_b_x;
  uint16_T *c5_b_u;
  boolean_T *c5_b_isOverSample;
  c5_b_isOverSample = (boolean_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c5_b_u = (uint16_T *)ssGetInputPortSignal(chartInstance->S, 0);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 4U, chartInstance->c5_sfEvent);
  _SFD_DATA_RANGE_CHECK((real_T)*c5_b_u, 0U);
  _SFD_DATA_RANGE_CHECK((real_T)*c5_b_isOverSample, 1U);
  chartInstance->c5_sfEvent = CALL_EVENT;
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 4U, chartInstance->c5_sfEvent);
  c5_hoistedGlobal = *c5_b_u;
  c5_u = c5_hoistedGlobal;
  _SFD_SYMBOL_SCOPE_PUSH_EML(0U, 10U, 10U, c5_debug_family_names,
    c5_debug_family_var_map);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c5_FILTER_SIZE, 0U, c5_f_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c5_SAMPLE_THRESHOLD, 1U,
    c5_f_sf_marshallOut, c5_e_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c5_avg, 2U, c5_f_sf_marshallOut,
    c5_e_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c5_nargin, 3U, c5_f_sf_marshallOut,
    c5_e_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c5_nargout, 4U, c5_f_sf_marshallOut,
    c5_e_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c5_u, 5U, c5_e_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c5_isOverSample, 6U, c5_d_sf_marshallOut,
    c5_d_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&chartInstance->c5_i, 7U,
    c5_c_sf_marshallOut, c5_c_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(chartInstance->c5_buf, 8U,
    c5_b_sf_marshallOut, c5_b_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&chartInstance->c5_bufSum, 9U,
    c5_sf_marshallOut, c5_sf_marshallIn);
  CV_EML_FCN(0, 0);
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 3);
  c5_FILTER_SIZE = 10.0;
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 5);
  c5_SAMPLE_THRESHOLD = 35.0;
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 7);
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 8);
  if (CV_EML_IF(0, 1, 0, !chartInstance->c5_buf_not_empty)) {
    _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 9);
    for (c5_i2 = 0; c5_i2 < 10; c5_i2++) {
      chartInstance->c5_buf[c5_i2] = 0.0;
    }

    chartInstance->c5_buf_not_empty = TRUE;
    _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 10);
    chartInstance->c5_bufSum = 0.0;
    chartInstance->c5_bufSum_not_empty = TRUE;
    _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 11);
    chartInstance->c5_i = 1.0;
    chartInstance->c5_i_not_empty = TRUE;
  }

  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 13);
  chartInstance->c5_bufSum -= chartInstance->c5_buf[(int32_T)(real_T)
    _SFD_EML_ARRAY_BOUNDS_CHECK("buf", (int32_T)_SFD_INTEGER_CHECK("i",
    chartInstance->c5_i), 1, 10, 1, 0) - 1];
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 14);
  chartInstance->c5_buf[(int32_T)(real_T)_SFD_EML_ARRAY_BOUNDS_CHECK("buf",
    (int32_T)_SFD_INTEGER_CHECK("i", chartInstance->c5_i), 1, 10, 1, 0) - 1] =
    (real_T)c5_u;
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 15);
  chartInstance->c5_bufSum += (real_T)c5_u;
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 16);
  chartInstance->c5_i++;
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 17);
  if (CV_EML_IF(0, 1, 1, chartInstance->c5_i > 10.0)) {
    _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 18);
    chartInstance->c5_i = 1.0;
  }

  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 20);
  c5_b_hoistedGlobal = chartInstance->c5_bufSum;
  c5_A = c5_b_hoistedGlobal;
  c5_x = c5_A;
  c5_b_x = c5_x;
  c5_avg = c5_b_x / 10.0;
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 22);
  if (CV_EML_IF(0, 1, 2, c5_avg < c5_SAMPLE_THRESHOLD)) {
    _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 23);
    c5_isOverSample = TRUE;
  } else {
    _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 25);
    c5_isOverSample = FALSE;
  }

  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, -25);
  _SFD_SYMBOL_SCOPE_POP();
  *c5_b_isOverSample = c5_isOverSample;
  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 4U, chartInstance->c5_sfEvent);
  _SFD_CHECK_FOR_STATE_INCONSISTENCY(_robulinkMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void initSimStructsc5_robulink(SFc5_robulinkInstanceStruct *chartInstance)
{
}

static void registerMessagesc5_robulink(SFc5_robulinkInstanceStruct
  *chartInstance)
{
}

static void init_script_number_translation(uint32_T c5_machineNumber, uint32_T
  c5_chartNumber)
{
}

static const mxArray *c5_sf_marshallOut(void *chartInstanceVoid, void *c5_inData)
{
  const mxArray *c5_mxArrayOutData = NULL;
  real_T c5_u;
  const mxArray *c5_y = NULL;
  SFc5_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc5_robulinkInstanceStruct *)chartInstanceVoid;
  c5_mxArrayOutData = NULL;
  c5_u = *(real_T *)c5_inData;
  c5_y = NULL;
  if (!chartInstance->c5_bufSum_not_empty) {
    sf_mex_assign(&c5_y, sf_mex_create("y", NULL, 0, 0U, 1U, 0U, 2, 0, 0), FALSE);
  } else {
    sf_mex_assign(&c5_y, sf_mex_create("y", &c5_u, 0, 0U, 0U, 0U, 0), FALSE);
  }

  sf_mex_assign(&c5_mxArrayOutData, c5_y, FALSE);
  return c5_mxArrayOutData;
}

static real_T c5_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_b_bufSum, const char_T *c5_identifier)
{
  real_T c5_y;
  emlrtMsgIdentifier c5_thisId;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_b_bufSum),
    &c5_thisId);
  sf_mex_destroy(&c5_b_bufSum);
  return c5_y;
}

static real_T c5_b_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId)
{
  real_T c5_y;
  real_T c5_d0;
  if (mxIsEmpty(c5_u)) {
    chartInstance->c5_bufSum_not_empty = FALSE;
  } else {
    chartInstance->c5_bufSum_not_empty = TRUE;
    sf_mex_import(c5_parentId, sf_mex_dup(c5_u), &c5_d0, 1, 0, 0U, 0, 0U, 0);
    c5_y = c5_d0;
  }

  sf_mex_destroy(&c5_u);
  return c5_y;
}

static void c5_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData)
{
  const mxArray *c5_b_bufSum;
  const char_T *c5_identifier;
  emlrtMsgIdentifier c5_thisId;
  real_T c5_y;
  SFc5_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc5_robulinkInstanceStruct *)chartInstanceVoid;
  c5_b_bufSum = sf_mex_dup(c5_mxArrayInData);
  c5_identifier = c5_varName;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_b_bufSum),
    &c5_thisId);
  sf_mex_destroy(&c5_b_bufSum);
  *(real_T *)c5_outData = c5_y;
  sf_mex_destroy(&c5_mxArrayInData);
}

static const mxArray *c5_b_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData)
{
  const mxArray *c5_mxArrayOutData = NULL;
  int32_T c5_i3;
  real_T c5_b_inData[10];
  int32_T c5_i4;
  real_T c5_u[10];
  const mxArray *c5_y = NULL;
  SFc5_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc5_robulinkInstanceStruct *)chartInstanceVoid;
  c5_mxArrayOutData = NULL;
  for (c5_i3 = 0; c5_i3 < 10; c5_i3++) {
    c5_b_inData[c5_i3] = (*(real_T (*)[10])c5_inData)[c5_i3];
  }

  for (c5_i4 = 0; c5_i4 < 10; c5_i4++) {
    c5_u[c5_i4] = c5_b_inData[c5_i4];
  }

  c5_y = NULL;
  if (!chartInstance->c5_buf_not_empty) {
    sf_mex_assign(&c5_y, sf_mex_create("y", NULL, 0, 0U, 1U, 0U, 2, 0, 0), FALSE);
  } else {
    sf_mex_assign(&c5_y, sf_mex_create("y", c5_u, 0, 0U, 1U, 0U, 2, 1, 10),
                  FALSE);
  }

  sf_mex_assign(&c5_mxArrayOutData, c5_y, FALSE);
  return c5_mxArrayOutData;
}

static void c5_c_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_b_buf, const char_T *c5_identifier, real_T c5_y[10])
{
  emlrtMsgIdentifier c5_thisId;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_d_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_b_buf), &c5_thisId, c5_y);
  sf_mex_destroy(&c5_b_buf);
}

static void c5_d_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId, real_T c5_y[10])
{
  real_T c5_dv1[10];
  int32_T c5_i5;
  if (mxIsEmpty(c5_u)) {
    chartInstance->c5_buf_not_empty = FALSE;
  } else {
    chartInstance->c5_buf_not_empty = TRUE;
    sf_mex_import(c5_parentId, sf_mex_dup(c5_u), c5_dv1, 1, 0, 0U, 1, 0U, 2, 1,
                  10);
    for (c5_i5 = 0; c5_i5 < 10; c5_i5++) {
      c5_y[c5_i5] = c5_dv1[c5_i5];
    }
  }

  sf_mex_destroy(&c5_u);
}

static void c5_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData)
{
  const mxArray *c5_b_buf;
  const char_T *c5_identifier;
  emlrtMsgIdentifier c5_thisId;
  real_T c5_y[10];
  int32_T c5_i6;
  SFc5_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc5_robulinkInstanceStruct *)chartInstanceVoid;
  c5_b_buf = sf_mex_dup(c5_mxArrayInData);
  c5_identifier = c5_varName;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_d_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_b_buf), &c5_thisId, c5_y);
  sf_mex_destroy(&c5_b_buf);
  for (c5_i6 = 0; c5_i6 < 10; c5_i6++) {
    (*(real_T (*)[10])c5_outData)[c5_i6] = c5_y[c5_i6];
  }

  sf_mex_destroy(&c5_mxArrayInData);
}

static const mxArray *c5_c_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData)
{
  const mxArray *c5_mxArrayOutData = NULL;
  real_T c5_u;
  const mxArray *c5_y = NULL;
  SFc5_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc5_robulinkInstanceStruct *)chartInstanceVoid;
  c5_mxArrayOutData = NULL;
  c5_u = *(real_T *)c5_inData;
  c5_y = NULL;
  if (!chartInstance->c5_i_not_empty) {
    sf_mex_assign(&c5_y, sf_mex_create("y", NULL, 0, 0U, 1U, 0U, 2, 0, 0), FALSE);
  } else {
    sf_mex_assign(&c5_y, sf_mex_create("y", &c5_u, 0, 0U, 0U, 0U, 0), FALSE);
  }

  sf_mex_assign(&c5_mxArrayOutData, c5_y, FALSE);
  return c5_mxArrayOutData;
}

static real_T c5_e_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_b_i, const char_T *c5_identifier)
{
  real_T c5_y;
  emlrtMsgIdentifier c5_thisId;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_f_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_b_i), &c5_thisId);
  sf_mex_destroy(&c5_b_i);
  return c5_y;
}

static real_T c5_f_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId)
{
  real_T c5_y;
  real_T c5_d1;
  if (mxIsEmpty(c5_u)) {
    chartInstance->c5_i_not_empty = FALSE;
  } else {
    chartInstance->c5_i_not_empty = TRUE;
    sf_mex_import(c5_parentId, sf_mex_dup(c5_u), &c5_d1, 1, 0, 0U, 0, 0U, 0);
    c5_y = c5_d1;
  }

  sf_mex_destroy(&c5_u);
  return c5_y;
}

static void c5_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData)
{
  const mxArray *c5_b_i;
  const char_T *c5_identifier;
  emlrtMsgIdentifier c5_thisId;
  real_T c5_y;
  SFc5_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc5_robulinkInstanceStruct *)chartInstanceVoid;
  c5_b_i = sf_mex_dup(c5_mxArrayInData);
  c5_identifier = c5_varName;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_f_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_b_i), &c5_thisId);
  sf_mex_destroy(&c5_b_i);
  *(real_T *)c5_outData = c5_y;
  sf_mex_destroy(&c5_mxArrayInData);
}

static const mxArray *c5_d_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData)
{
  const mxArray *c5_mxArrayOutData = NULL;
  boolean_T c5_u;
  const mxArray *c5_y = NULL;
  SFc5_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc5_robulinkInstanceStruct *)chartInstanceVoid;
  c5_mxArrayOutData = NULL;
  c5_u = *(boolean_T *)c5_inData;
  c5_y = NULL;
  sf_mex_assign(&c5_y, sf_mex_create("y", &c5_u, 11, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c5_mxArrayOutData, c5_y, FALSE);
  return c5_mxArrayOutData;
}

static boolean_T c5_g_emlrt_marshallIn(SFc5_robulinkInstanceStruct
  *chartInstance, const mxArray *c5_isOverSample, const char_T *c5_identifier)
{
  boolean_T c5_y;
  emlrtMsgIdentifier c5_thisId;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_h_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_isOverSample),
    &c5_thisId);
  sf_mex_destroy(&c5_isOverSample);
  return c5_y;
}

static boolean_T c5_h_emlrt_marshallIn(SFc5_robulinkInstanceStruct
  *chartInstance, const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId)
{
  boolean_T c5_y;
  boolean_T c5_b0;
  sf_mex_import(c5_parentId, sf_mex_dup(c5_u), &c5_b0, 1, 11, 0U, 0, 0U, 0);
  c5_y = c5_b0;
  sf_mex_destroy(&c5_u);
  return c5_y;
}

static void c5_d_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData)
{
  const mxArray *c5_isOverSample;
  const char_T *c5_identifier;
  emlrtMsgIdentifier c5_thisId;
  boolean_T c5_y;
  SFc5_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc5_robulinkInstanceStruct *)chartInstanceVoid;
  c5_isOverSample = sf_mex_dup(c5_mxArrayInData);
  c5_identifier = c5_varName;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_h_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_isOverSample),
    &c5_thisId);
  sf_mex_destroy(&c5_isOverSample);
  *(boolean_T *)c5_outData = c5_y;
  sf_mex_destroy(&c5_mxArrayInData);
}

static const mxArray *c5_e_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData)
{
  const mxArray *c5_mxArrayOutData = NULL;
  uint16_T c5_u;
  const mxArray *c5_y = NULL;
  SFc5_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc5_robulinkInstanceStruct *)chartInstanceVoid;
  c5_mxArrayOutData = NULL;
  c5_u = *(uint16_T *)c5_inData;
  c5_y = NULL;
  sf_mex_assign(&c5_y, sf_mex_create("y", &c5_u, 5, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c5_mxArrayOutData, c5_y, FALSE);
  return c5_mxArrayOutData;
}

static const mxArray *c5_f_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData)
{
  const mxArray *c5_mxArrayOutData = NULL;
  real_T c5_u;
  const mxArray *c5_y = NULL;
  SFc5_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc5_robulinkInstanceStruct *)chartInstanceVoid;
  c5_mxArrayOutData = NULL;
  c5_u = *(real_T *)c5_inData;
  c5_y = NULL;
  sf_mex_assign(&c5_y, sf_mex_create("y", &c5_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c5_mxArrayOutData, c5_y, FALSE);
  return c5_mxArrayOutData;
}

static real_T c5_i_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId)
{
  real_T c5_y;
  real_T c5_d2;
  sf_mex_import(c5_parentId, sf_mex_dup(c5_u), &c5_d2, 1, 0, 0U, 0, 0U, 0);
  c5_y = c5_d2;
  sf_mex_destroy(&c5_u);
  return c5_y;
}

static void c5_e_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData)
{
  const mxArray *c5_nargout;
  const char_T *c5_identifier;
  emlrtMsgIdentifier c5_thisId;
  real_T c5_y;
  SFc5_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc5_robulinkInstanceStruct *)chartInstanceVoid;
  c5_nargout = sf_mex_dup(c5_mxArrayInData);
  c5_identifier = c5_varName;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_i_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_nargout), &c5_thisId);
  sf_mex_destroy(&c5_nargout);
  *(real_T *)c5_outData = c5_y;
  sf_mex_destroy(&c5_mxArrayInData);
}

const mxArray *sf_c5_robulink_get_eml_resolved_functions_info(void)
{
  const mxArray *c5_nameCaptureInfo;
  c5_ResolvedFunctionInfo c5_info[4];
  c5_ResolvedFunctionInfo (*c5_b_info)[4];
  const mxArray *c5_m0 = NULL;
  int32_T c5_i7;
  c5_ResolvedFunctionInfo *c5_r0;
  c5_nameCaptureInfo = NULL;
  c5_nameCaptureInfo = NULL;
  c5_b_info = (c5_ResolvedFunctionInfo (*)[4])c5_info;
  (*c5_b_info)[0].context = "";
  (*c5_b_info)[0].name = "mrdivide";
  (*c5_b_info)[0].dominantType = "double";
  (*c5_b_info)[0].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  (*c5_b_info)[0].fileTimeLo = 1357973148U;
  (*c5_b_info)[0].fileTimeHi = 0U;
  (*c5_b_info)[0].mFileTimeLo = 1319751566U;
  (*c5_b_info)[0].mFileTimeHi = 0U;
  (*c5_b_info)[1].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  (*c5_b_info)[1].name = "rdivide";
  (*c5_b_info)[1].dominantType = "double";
  (*c5_b_info)[1].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  (*c5_b_info)[1].fileTimeLo = 1346531988U;
  (*c5_b_info)[1].fileTimeHi = 0U;
  (*c5_b_info)[1].mFileTimeLo = 0U;
  (*c5_b_info)[1].mFileTimeHi = 0U;
  (*c5_b_info)[2].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  (*c5_b_info)[2].name = "eml_scalexp_compatible";
  (*c5_b_info)[2].dominantType = "double";
  (*c5_b_info)[2].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_compatible.m";
  (*c5_b_info)[2].fileTimeLo = 1286840396U;
  (*c5_b_info)[2].fileTimeHi = 0U;
  (*c5_b_info)[2].mFileTimeLo = 0U;
  (*c5_b_info)[2].mFileTimeHi = 0U;
  (*c5_b_info)[3].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  (*c5_b_info)[3].name = "eml_div";
  (*c5_b_info)[3].dominantType = "double";
  (*c5_b_info)[3].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_div.m";
  (*c5_b_info)[3].fileTimeLo = 1313369410U;
  (*c5_b_info)[3].fileTimeHi = 0U;
  (*c5_b_info)[3].mFileTimeLo = 0U;
  (*c5_b_info)[3].mFileTimeHi = 0U;
  sf_mex_assign(&c5_m0, sf_mex_createstruct("nameCaptureInfo", 1, 4), FALSE);
  for (c5_i7 = 0; c5_i7 < 4; c5_i7++) {
    c5_r0 = &c5_info[c5_i7];
    sf_mex_addfield(c5_m0, sf_mex_create("nameCaptureInfo", c5_r0->context, 15,
      0U, 0U, 0U, 2, 1, strlen(c5_r0->context)), "context", "nameCaptureInfo",
                    c5_i7);
    sf_mex_addfield(c5_m0, sf_mex_create("nameCaptureInfo", c5_r0->name, 15, 0U,
      0U, 0U, 2, 1, strlen(c5_r0->name)), "name", "nameCaptureInfo", c5_i7);
    sf_mex_addfield(c5_m0, sf_mex_create("nameCaptureInfo", c5_r0->dominantType,
      15, 0U, 0U, 0U, 2, 1, strlen(c5_r0->dominantType)), "dominantType",
                    "nameCaptureInfo", c5_i7);
    sf_mex_addfield(c5_m0, sf_mex_create("nameCaptureInfo", c5_r0->resolved, 15,
      0U, 0U, 0U, 2, 1, strlen(c5_r0->resolved)), "resolved", "nameCaptureInfo",
                    c5_i7);
    sf_mex_addfield(c5_m0, sf_mex_create("nameCaptureInfo", &c5_r0->fileTimeLo,
      7, 0U, 0U, 0U, 0), "fileTimeLo", "nameCaptureInfo", c5_i7);
    sf_mex_addfield(c5_m0, sf_mex_create("nameCaptureInfo", &c5_r0->fileTimeHi,
      7, 0U, 0U, 0U, 0), "fileTimeHi", "nameCaptureInfo", c5_i7);
    sf_mex_addfield(c5_m0, sf_mex_create("nameCaptureInfo", &c5_r0->mFileTimeLo,
      7, 0U, 0U, 0U, 0), "mFileTimeLo", "nameCaptureInfo", c5_i7);
    sf_mex_addfield(c5_m0, sf_mex_create("nameCaptureInfo", &c5_r0->mFileTimeHi,
      7, 0U, 0U, 0U, 0), "mFileTimeHi", "nameCaptureInfo", c5_i7);
  }

  sf_mex_assign(&c5_nameCaptureInfo, c5_m0, FALSE);
  sf_mex_emlrtNameCapturePostProcessR2012a(&c5_nameCaptureInfo);
  return c5_nameCaptureInfo;
}

static const mxArray *c5_g_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData)
{
  const mxArray *c5_mxArrayOutData = NULL;
  int32_T c5_u;
  const mxArray *c5_y = NULL;
  SFc5_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc5_robulinkInstanceStruct *)chartInstanceVoid;
  c5_mxArrayOutData = NULL;
  c5_u = *(int32_T *)c5_inData;
  c5_y = NULL;
  sf_mex_assign(&c5_y, sf_mex_create("y", &c5_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c5_mxArrayOutData, c5_y, FALSE);
  return c5_mxArrayOutData;
}

static int32_T c5_j_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId)
{
  int32_T c5_y;
  int32_T c5_i8;
  sf_mex_import(c5_parentId, sf_mex_dup(c5_u), &c5_i8, 1, 6, 0U, 0, 0U, 0);
  c5_y = c5_i8;
  sf_mex_destroy(&c5_u);
  return c5_y;
}

static void c5_f_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData)
{
  const mxArray *c5_b_sfEvent;
  const char_T *c5_identifier;
  emlrtMsgIdentifier c5_thisId;
  int32_T c5_y;
  SFc5_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc5_robulinkInstanceStruct *)chartInstanceVoid;
  c5_b_sfEvent = sf_mex_dup(c5_mxArrayInData);
  c5_identifier = c5_varName;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_j_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_b_sfEvent),
    &c5_thisId);
  sf_mex_destroy(&c5_b_sfEvent);
  *(int32_T *)c5_outData = c5_y;
  sf_mex_destroy(&c5_mxArrayInData);
}

static uint8_T c5_k_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_b_is_active_c5_robulink, const char_T *c5_identifier)
{
  uint8_T c5_y;
  emlrtMsgIdentifier c5_thisId;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_l_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c5_b_is_active_c5_robulink), &c5_thisId);
  sf_mex_destroy(&c5_b_is_active_c5_robulink);
  return c5_y;
}

static uint8_T c5_l_emlrt_marshallIn(SFc5_robulinkInstanceStruct *chartInstance,
  const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId)
{
  uint8_T c5_y;
  uint8_T c5_u0;
  sf_mex_import(c5_parentId, sf_mex_dup(c5_u), &c5_u0, 1, 3, 0U, 0, 0U, 0);
  c5_y = c5_u0;
  sf_mex_destroy(&c5_u);
  return c5_y;
}

static void init_dsm_address_info(SFc5_robulinkInstanceStruct *chartInstance)
{
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

void sf_c5_robulink_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3458206650U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(440055981U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(2040116684U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(1082970036U);
}

mxArray *sf_c5_robulink_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("6froZN5reQXXC1ASqmgEfD");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,1,3,dataFields);

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
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(5));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"inputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"parameters",mxCreateDoubleMatrix(0,0,
                mxREAL));
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,1,3,dataFields);

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
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(1));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"outputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"locals",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  return(mxAutoinheritanceInfo);
}

mxArray *sf_c5_robulink_third_party_uses_info(void)
{
  mxArray * mxcell3p = mxCreateCellMatrix(1,0);
  return(mxcell3p);
}

static const mxArray *sf_get_sim_state_info_c5_robulink(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x5'type','srcId','name','auxInfo'{{M[1],M[5],T\"isOverSample\",},{M[4],M[0],T\"buf\",S'l','i','p'{{M1x2[154 157],M[0],}}},{M[4],M[0],T\"bufSum\",S'l','i','p'{{M1x2[158 164],M[0],}}},{M[4],M[0],T\"i\",S'l','i','p'{{M1x2[152 153],M[0],}}},{M[8],M[0],T\"is_active_c5_robulink\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 5, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c5_robulink_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc5_robulinkInstanceStruct *chartInstance;
    chartInstance = (SFc5_robulinkInstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (sfGlobalDebugInstanceStruct,
           _robulinkMachineNumber_,
           5,
           1,
           1,
           2,
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
          _SFD_SET_DATA_PROPS(0,1,1,0,"u");
          _SFD_SET_DATA_PROPS(1,2,0,1,"isOverSample");
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
        _SFD_CV_INIT_EML(0,1,1,3,0,0,0,0,0,0,0);
        _SFD_CV_INIT_EML_FCN(0,0,"eML_blk_kernel",0,-1,477);
        _SFD_CV_INIT_EML_IF(0,1,0,166,181,-1,244);
        _SFD_CV_INIT_EML_IF(0,1,1,331,348,-1,363);
        _SFD_CV_INIT_EML_IF(0,1,2,392,417,443,477);
        _SFD_TRANS_COV_WTS(0,0,0,1,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              1,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_UINT16,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c5_e_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(1,SF_UINT8,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c5_d_sf_marshallOut,(MexInFcnForType)c5_d_sf_marshallIn);

        {
          uint16_T *c5_u;
          boolean_T *c5_isOverSample;
          c5_isOverSample = (boolean_T *)ssGetOutputPortSignal(chartInstance->S,
            1);
          c5_u = (uint16_T *)ssGetInputPortSignal(chartInstance->S, 0);
          _SFD_SET_DATA_VALUE_PTR(0U, c5_u);
          _SFD_SET_DATA_VALUE_PTR(1U, c5_isOverSample);
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
  return "b54CsUjXkQoC7aGnAfMRWB";
}

static void sf_opaque_initialize_c5_robulink(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc5_robulinkInstanceStruct*) chartInstanceVar)
    ->S,0);
  initialize_params_c5_robulink((SFc5_robulinkInstanceStruct*) chartInstanceVar);
  initialize_c5_robulink((SFc5_robulinkInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_enable_c5_robulink(void *chartInstanceVar)
{
  enable_c5_robulink((SFc5_robulinkInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_disable_c5_robulink(void *chartInstanceVar)
{
  disable_c5_robulink((SFc5_robulinkInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_gateway_c5_robulink(void *chartInstanceVar)
{
  sf_c5_robulink((SFc5_robulinkInstanceStruct*) chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c5_robulink(SimStruct* S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c5_robulink((SFc5_robulinkInstanceStruct*)
    chartInfo->chartInstance);         /* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c5_robulink();/* state var info */
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

extern void sf_internal_set_sim_state_c5_robulink(SimStruct* S, const mxArray
  *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c5_robulink();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c5_robulink((SFc5_robulinkInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c5_robulink(SimStruct* S)
{
  return sf_internal_get_sim_state_c5_robulink(S);
}

static void sf_opaque_set_sim_state_c5_robulink(SimStruct* S, const mxArray *st)
{
  sf_internal_set_sim_state_c5_robulink(S, st);
}

static void sf_opaque_terminate_c5_robulink(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc5_robulinkInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
      unload_robulink_optimization_info();
    }

    finalize_c5_robulink((SFc5_robulinkInstanceStruct*) chartInstanceVar);
    utFree((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc5_robulink((SFc5_robulinkInstanceStruct*) chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c5_robulink(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c5_robulink((SFc5_robulinkInstanceStruct*)
      (((ChartInfoStruct *)ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c5_robulink(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_robulink_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      5);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,5,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,5,
      "gatewayCannotBeInlinedMultipleTimes"));
    sf_update_buildInfo(S,sf_get_instance_specialization(),infoStruct,5);
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,5,1);
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,5,1);
    }

    {
      unsigned int outPortIdx;
      for (outPortIdx=1; outPortIdx<=1; ++outPortIdx) {
        ssSetOutputPortOptimizeInIR(S, outPortIdx, 1U);
      }
    }

    {
      unsigned int inPortIdx;
      for (inPortIdx=0; inPortIdx < 1; ++inPortIdx) {
        ssSetInputPortOptimizeInIR(S, inPortIdx, 1U);
      }
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,5);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(2768373411U));
  ssSetChecksum1(S,(973551905U));
  ssSetChecksum2(S,(2839750763U));
  ssSetChecksum3(S,(1558732062U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
  ssSupportsMultipleExecInstances(S,1);
}

static void mdlRTW_c5_robulink(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Embedded MATLAB");
  }
}

static void mdlStart_c5_robulink(SimStruct *S)
{
  SFc5_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc5_robulinkInstanceStruct *)utMalloc(sizeof
    (SFc5_robulinkInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc5_robulinkInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 1;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway = sf_opaque_gateway_c5_robulink;
  chartInstance->chartInfo.initializeChart = sf_opaque_initialize_c5_robulink;
  chartInstance->chartInfo.terminateChart = sf_opaque_terminate_c5_robulink;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c5_robulink;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c5_robulink;
  chartInstance->chartInfo.getSimState = sf_opaque_get_sim_state_c5_robulink;
  chartInstance->chartInfo.setSimState = sf_opaque_set_sim_state_c5_robulink;
  chartInstance->chartInfo.getSimStateInfo = sf_get_sim_state_info_c5_robulink;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c5_robulink;
  chartInstance->chartInfo.mdlStart = mdlStart_c5_robulink;
  chartInstance->chartInfo.mdlSetWorkWidths = mdlSetWorkWidths_c5_robulink;
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

void c5_robulink_method_dispatcher(SimStruct *S, int_T method, void *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c5_robulink(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c5_robulink(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c5_robulink(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c5_robulink_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}

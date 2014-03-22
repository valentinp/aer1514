/* Include files */

#include <stddef.h>
#include "blas.h"
#include "robulink_sfun.h"
#include "c1_robulink.h"
#include "mwmathutil.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "robulink_sfun_debug_macros.h"
#define _SF_MEX_LISTEN_FOR_CTRL_C(S)   sf_mex_listen_for_ctrl_c(sfGlobalDebugInstanceStruct,S);

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)

/* Variable Declarations */

/* Variable Definitions */
static const char * c1_debug_family_names[14] = { "sampleTime", "wheelRadius",
  "wheelSeparation", "omegaL", "omegaR", "B", "update", "nargin", "nargout",
  "wheelEncoderL", "wheelEncoderR", "theta", "x", "y" };

/* Function Declarations */
static void initialize_c1_robulink(SFc1_robulinkInstanceStruct *chartInstance);
static void initialize_params_c1_robulink(SFc1_robulinkInstanceStruct
  *chartInstance);
static void enable_c1_robulink(SFc1_robulinkInstanceStruct *chartInstance);
static void disable_c1_robulink(SFc1_robulinkInstanceStruct *chartInstance);
static void c1_update_debugger_state_c1_robulink(SFc1_robulinkInstanceStruct
  *chartInstance);
static const mxArray *get_sim_state_c1_robulink(SFc1_robulinkInstanceStruct
  *chartInstance);
static void set_sim_state_c1_robulink(SFc1_robulinkInstanceStruct *chartInstance,
  const mxArray *c1_st);
static void finalize_c1_robulink(SFc1_robulinkInstanceStruct *chartInstance);
static void sf_c1_robulink(SFc1_robulinkInstanceStruct *chartInstance);
static void c1_chartstep_c1_robulink(SFc1_robulinkInstanceStruct *chartInstance);
static void initSimStructsc1_robulink(SFc1_robulinkInstanceStruct *chartInstance);
static void registerMessagesc1_robulink(SFc1_robulinkInstanceStruct
  *chartInstance);
static void init_script_number_translation(uint32_T c1_machineNumber, uint32_T
  c1_chartNumber);
static const mxArray *c1_sf_marshallOut(void *chartInstanceVoid, void *c1_inData);
static real_T c1_emlrt_marshallIn(SFc1_robulinkInstanceStruct *chartInstance,
  const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId);
static void c1_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c1_mxArrayInData, const char_T *c1_varName, void *c1_outData);
static const mxArray *c1_b_sf_marshallOut(void *chartInstanceVoid, void
  *c1_inData);
static const mxArray *c1_c_sf_marshallOut(void *chartInstanceVoid, void
  *c1_inData);
static void c1_b_emlrt_marshallIn(SFc1_robulinkInstanceStruct *chartInstance,
  const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId, real_T c1_y[3]);
static void c1_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c1_mxArrayInData, const char_T *c1_varName, void *c1_outData);
static const mxArray *c1_d_sf_marshallOut(void *chartInstanceVoid, void
  *c1_inData);
static void c1_c_emlrt_marshallIn(SFc1_robulinkInstanceStruct *chartInstance,
  const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId, real_T c1_y[6]);
static void c1_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c1_mxArrayInData, const char_T *c1_varName, void *c1_outData);
static void c1_info_helper(c1_ResolvedFunctionInfo c1_info[30]);
static real_T c1_cosd(SFc1_robulinkInstanceStruct *chartInstance, real_T c1_x);
static real_T c1_sind(SFc1_robulinkInstanceStruct *chartInstance, real_T c1_x);
static void c1_eml_scalar_eg(SFc1_robulinkInstanceStruct *chartInstance);
static int32_T c1_d_emlrt_marshallIn(SFc1_robulinkInstanceStruct *chartInstance,
  const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId);
static void c1_d_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c1_mxArrayInData, const char_T *c1_varName, void *c1_outData);
static uint8_T c1_e_emlrt_marshallIn(SFc1_robulinkInstanceStruct *chartInstance,
  const mxArray *c1_b_is_active_c1_robulink, const char_T *c1_identifier);
static uint8_T c1_f_emlrt_marshallIn(SFc1_robulinkInstanceStruct *chartInstance,
  const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId);
static void c1_b_cosd(SFc1_robulinkInstanceStruct *chartInstance, real_T *c1_x);
static void c1_b_sind(SFc1_robulinkInstanceStruct *chartInstance, real_T *c1_x);
static real_T c1_get_theta(SFc1_robulinkInstanceStruct *chartInstance, uint32_T
  c1_b);
static void c1_set_theta(SFc1_robulinkInstanceStruct *chartInstance, uint32_T
  c1_b, real_T c1_c);
static real_T *c1_access_theta(SFc1_robulinkInstanceStruct *chartInstance,
  uint32_T c1_b);
static real_T c1_get_x(SFc1_robulinkInstanceStruct *chartInstance, uint32_T c1_b);
static void c1_set_x(SFc1_robulinkInstanceStruct *chartInstance, uint32_T c1_b,
                     real_T c1_c);
static real_T *c1_access_x(SFc1_robulinkInstanceStruct *chartInstance, uint32_T
  c1_b);
static real_T c1_get_y(SFc1_robulinkInstanceStruct *chartInstance, uint32_T c1_b);
static void c1_set_y(SFc1_robulinkInstanceStruct *chartInstance, uint32_T c1_b,
                     real_T c1_c);
static real_T *c1_access_y(SFc1_robulinkInstanceStruct *chartInstance, uint32_T
  c1_b);
static void init_dsm_address_info(SFc1_robulinkInstanceStruct *chartInstance);

/* Function Definitions */
static void initialize_c1_robulink(SFc1_robulinkInstanceStruct *chartInstance)
{
  chartInstance->c1_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c1_is_active_c1_robulink = 0U;
}

static void initialize_params_c1_robulink(SFc1_robulinkInstanceStruct
  *chartInstance)
{
}

static void enable_c1_robulink(SFc1_robulinkInstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c1_robulink(SFc1_robulinkInstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void c1_update_debugger_state_c1_robulink(SFc1_robulinkInstanceStruct
  *chartInstance)
{
}

static const mxArray *get_sim_state_c1_robulink(SFc1_robulinkInstanceStruct
  *chartInstance)
{
  const mxArray *c1_st;
  const mxArray *c1_y = NULL;
  uint8_T c1_hoistedGlobal;
  uint8_T c1_u;
  const mxArray *c1_b_y = NULL;
  c1_st = NULL;
  c1_st = NULL;
  c1_y = NULL;
  sf_mex_assign(&c1_y, sf_mex_createcellarray(1), FALSE);
  c1_hoistedGlobal = chartInstance->c1_is_active_c1_robulink;
  c1_u = c1_hoistedGlobal;
  c1_b_y = NULL;
  sf_mex_assign(&c1_b_y, sf_mex_create("y", &c1_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c1_y, 0, c1_b_y);
  sf_mex_assign(&c1_st, c1_y, FALSE);
  return c1_st;
}

static void set_sim_state_c1_robulink(SFc1_robulinkInstanceStruct *chartInstance,
  const mxArray *c1_st)
{
  const mxArray *c1_u;
  chartInstance->c1_doneDoubleBufferReInit = TRUE;
  c1_u = sf_mex_dup(c1_st);
  chartInstance->c1_is_active_c1_robulink = c1_e_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c1_u, 0)), "is_active_c1_robulink");
  sf_mex_destroy(&c1_u);
  c1_update_debugger_state_c1_robulink(chartInstance);
  sf_mex_destroy(&c1_st);
}

static void finalize_c1_robulink(SFc1_robulinkInstanceStruct *chartInstance)
{
}

static void sf_c1_robulink(SFc1_robulinkInstanceStruct *chartInstance)
{
  int32_T *c1_wheelEncoderL;
  int32_T *c1_wheelEncoderR;
  c1_wheelEncoderR = (int32_T *)ssGetInputPortSignal(chartInstance->S, 1);
  c1_wheelEncoderL = (int32_T *)ssGetInputPortSignal(chartInstance->S, 0);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 0U, chartInstance->c1_sfEvent);
  _SFD_DATA_RANGE_CHECK((real_T)*c1_wheelEncoderL, 0U);
  _SFD_DATA_RANGE_CHECK((real_T)*c1_wheelEncoderR, 1U);
  chartInstance->c1_sfEvent = CALL_EVENT;
  c1_chartstep_c1_robulink(chartInstance);
  _SFD_CHECK_FOR_STATE_INCONSISTENCY(_robulinkMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void c1_chartstep_c1_robulink(SFc1_robulinkInstanceStruct *chartInstance)
{
  int32_T c1_hoistedGlobal;
  int32_T c1_b_hoistedGlobal;
  int32_T c1_wheelEncoderL;
  int32_T c1_wheelEncoderR;
  uint32_T c1_debug_family_var_map[14];
  real_T c1_sampleTime;
  real_T c1_wheelRadius;
  real_T c1_wheelSeparation;
  real_T c1_omegaL;
  real_T c1_omegaR;
  real_T c1_B[6];
  real_T c1_update[3];
  real_T c1_nargin = 2.0;
  real_T c1_nargout = 0.0;
  real_T c1_A;
  real_T c1_x;
  real_T c1_b_x;
  real_T c1_b_A;
  real_T c1_c_x;
  real_T c1_d_x;
  real_T c1_c_hoistedGlobal;
  real_T c1_b;
  real_T c1_y;
  real_T c1_d_hoistedGlobal;
  real_T c1_b_b;
  real_T c1_b_y;
  real_T c1_e_hoistedGlobal;
  real_T c1_c_b;
  real_T c1_c_y;
  real_T c1_f_hoistedGlobal;
  real_T c1_d_b;
  real_T c1_d_y;
  int32_T c1_i0;
  int32_T c1_i1;
  int32_T c1_i2;
  real_T c1_e_b[6];
  int32_T c1_i3;
  int32_T c1_i4;
  real_T c1_f_b[2];
  int32_T c1_i5;
  int32_T c1_i6;
  int32_T c1_i7;
  real_T c1_C[3];
  int32_T c1_i8;
  int32_T c1_i9;
  int32_T c1_i10;
  int32_T c1_i11;
  int32_T c1_i12;
  int32_T c1_i13;
  real_T c1_g_hoistedGlobal;
  real_T c1_a;
  real_T c1_e_y;
  real_T c1_c_A;
  real_T c1_e_x;
  real_T c1_f_x;
  real_T c1_f_y;
  int32_T *c1_b_wheelEncoderL;
  int32_T *c1_b_wheelEncoderR;
  c1_b_wheelEncoderR = (int32_T *)ssGetInputPortSignal(chartInstance->S, 1);
  c1_b_wheelEncoderL = (int32_T *)ssGetInputPortSignal(chartInstance->S, 0);
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 0U, chartInstance->c1_sfEvent);
  c1_hoistedGlobal = *c1_b_wheelEncoderL;
  c1_b_hoistedGlobal = *c1_b_wheelEncoderR;
  c1_wheelEncoderL = c1_hoistedGlobal;
  c1_wheelEncoderR = c1_b_hoistedGlobal;
  _SFD_SYMBOL_SCOPE_PUSH_EML(0U, 14U, 14U, c1_debug_family_names,
    c1_debug_family_var_map);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c1_sampleTime, 0U, c1_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c1_wheelRadius, 1U, c1_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c1_wheelSeparation, 2U, c1_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c1_omegaL, 3U, c1_sf_marshallOut,
    c1_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c1_omegaR, 4U, c1_sf_marshallOut,
    c1_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(c1_B, 5U, c1_d_sf_marshallOut,
    c1_c_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(c1_update, 6U, c1_c_sf_marshallOut,
    c1_b_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c1_nargin, 7U, c1_sf_marshallOut,
    c1_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c1_nargout, 8U, c1_sf_marshallOut,
    c1_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c1_wheelEncoderL, 9U, c1_b_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c1_wheelEncoderR, 10U, c1_b_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(chartInstance->c1_theta_address, 11U,
    c1_sf_marshallOut, c1_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(chartInstance->c1_x_address, 12U,
    c1_sf_marshallOut, c1_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(chartInstance->c1_y_address, 13U,
    c1_sf_marshallOut, c1_sf_marshallIn);
  CV_EML_FCN(0, 0);
  _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, 13);
  _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, 14);
  _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, 15);
  _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, 18);
  c1_sampleTime = 0.1;
  _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, 20);
  c1_wheelRadius = 0.04;
  _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, 21);
  c1_wheelSeparation = 0.15;
  _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, 25);
  c1_A = -(real_T)c1_wheelEncoderL;
  c1_x = c1_A;
  c1_b_x = c1_x;
  c1_omegaL = c1_b_x / 0.1;
  _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, 26);
  c1_b_A = -(real_T)c1_wheelEncoderR;
  c1_c_x = c1_b_A;
  c1_d_x = c1_c_x;
  c1_omegaR = c1_d_x / 0.1;
  _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, 28);
  c1_c_hoistedGlobal = c1_get_theta(chartInstance, 0);
  c1_b = c1_c_hoistedGlobal;
  c1_b_cosd(chartInstance, &c1_b);
  c1_y = 0.02 * c1_b;
  c1_d_hoistedGlobal = c1_get_theta(chartInstance, 0);
  c1_b_b = c1_d_hoistedGlobal;
  c1_b_cosd(chartInstance, &c1_b_b);
  c1_b_y = 0.02 * c1_b_b;
  c1_e_hoistedGlobal = c1_get_theta(chartInstance, 0);
  c1_c_b = c1_e_hoistedGlobal;
  c1_b_sind(chartInstance, &c1_c_b);
  c1_c_y = 0.02 * c1_c_b;
  c1_f_hoistedGlobal = c1_get_theta(chartInstance, 0);
  c1_d_b = c1_f_hoistedGlobal;
  c1_b_sind(chartInstance, &c1_d_b);
  c1_d_y = 0.02 * c1_d_b;
  c1_B[0] = c1_y;
  c1_B[3] = c1_b_y;
  c1_B[1] = c1_c_y;
  c1_B[4] = c1_d_y;
  c1_i0 = 0;
  for (c1_i1 = 0; c1_i1 < 2; c1_i1++) {
    c1_B[c1_i0 + 2] = 0.26666666666666666 + -0.53333333333333333 * (real_T)c1_i1;
    c1_i0 += 3;
  }

  _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, 32);
  for (c1_i2 = 0; c1_i2 < 6; c1_i2++) {
    c1_e_b[c1_i2] = c1_B[c1_i2];
  }

  for (c1_i3 = 0; c1_i3 < 6; c1_i3++) {
    c1_e_b[c1_i3] *= 0.1;
  }

  for (c1_i4 = 0; c1_i4 < 6; c1_i4++) {
    c1_e_b[c1_i4] *= 0.017453292519943295;
  }

  c1_f_b[0] = c1_omegaR;
  c1_f_b[1] = c1_omegaL;
  c1_eml_scalar_eg(chartInstance);
  c1_eml_scalar_eg(chartInstance);
  for (c1_i5 = 0; c1_i5 < 3; c1_i5++) {
    c1_update[c1_i5] = 0.0;
  }

  for (c1_i6 = 0; c1_i6 < 3; c1_i6++) {
    c1_update[c1_i6] = 0.0;
  }

  for (c1_i7 = 0; c1_i7 < 3; c1_i7++) {
    c1_C[c1_i7] = c1_update[c1_i7];
  }

  for (c1_i8 = 0; c1_i8 < 3; c1_i8++) {
    c1_update[c1_i8] = c1_C[c1_i8];
  }

  for (c1_i9 = 0; c1_i9 < 3; c1_i9++) {
    c1_C[c1_i9] = c1_update[c1_i9];
  }

  for (c1_i10 = 0; c1_i10 < 3; c1_i10++) {
    c1_update[c1_i10] = c1_C[c1_i10];
  }

  for (c1_i11 = 0; c1_i11 < 3; c1_i11++) {
    c1_update[c1_i11] = 0.0;
    c1_i12 = 0;
    for (c1_i13 = 0; c1_i13 < 2; c1_i13++) {
      c1_update[c1_i11] += c1_e_b[c1_i12 + c1_i11] * c1_f_b[c1_i13];
      c1_i12 += 3;
    }
  }

  _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, 35);
  c1_set_x(chartInstance, 0, c1_get_x(chartInstance, 0) + c1_update[0]);
  ssUpdateDataStoreLog(chartInstance->S, 1);
  _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, 36);
  c1_set_y(chartInstance, 0, c1_get_y(chartInstance, 0) + c1_update[1]);
  ssUpdateDataStoreLog(chartInstance->S, 2);
  _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, 37);
  c1_g_hoistedGlobal = c1_get_theta(chartInstance, 0);
  c1_a = c1_update[2];
  c1_e_y = c1_a * 180.0;
  c1_c_A = c1_e_y;
  c1_e_x = c1_c_A;
  c1_f_x = c1_e_x;
  c1_f_y = c1_f_x / 3.1415926535897931;
  c1_set_theta(chartInstance, 0, c1_g_hoistedGlobal + c1_f_y);
  ssUpdateDataStoreLog(chartInstance->S, 0);
  _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, 39);
  if (CV_EML_IF(0, 1, 0, c1_get_theta(chartInstance, 0) > 180.0)) {
    _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, 40);
    c1_set_theta(chartInstance, 0, c1_get_theta(chartInstance, 0) - 360.0);
    ssUpdateDataStoreLog(chartInstance->S, 0);
  } else {
    _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, 41);
    if (CV_EML_IF(0, 1, 1, c1_get_theta(chartInstance, 0) <= -180.0)) {
      _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, 42);
      c1_set_theta(chartInstance, 0, c1_get_theta(chartInstance, 0) + 360.0);
      ssUpdateDataStoreLog(chartInstance->S, 0);
    }
  }

  _SFD_EML_CALL(0U, chartInstance->c1_sfEvent, -42);
  _SFD_SYMBOL_SCOPE_POP();
  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 0U, chartInstance->c1_sfEvent);
}

static void initSimStructsc1_robulink(SFc1_robulinkInstanceStruct *chartInstance)
{
}

static void registerMessagesc1_robulink(SFc1_robulinkInstanceStruct
  *chartInstance)
{
}

static void init_script_number_translation(uint32_T c1_machineNumber, uint32_T
  c1_chartNumber)
{
}

static const mxArray *c1_sf_marshallOut(void *chartInstanceVoid, void *c1_inData)
{
  const mxArray *c1_mxArrayOutData = NULL;
  real_T c1_u;
  const mxArray *c1_y = NULL;
  SFc1_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc1_robulinkInstanceStruct *)chartInstanceVoid;
  c1_mxArrayOutData = NULL;
  c1_u = *(real_T *)c1_inData;
  c1_y = NULL;
  sf_mex_assign(&c1_y, sf_mex_create("y", &c1_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c1_mxArrayOutData, c1_y, FALSE);
  return c1_mxArrayOutData;
}

static real_T c1_emlrt_marshallIn(SFc1_robulinkInstanceStruct *chartInstance,
  const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId)
{
  real_T c1_y;
  real_T c1_d0;
  sf_mex_import(c1_parentId, sf_mex_dup(c1_u), &c1_d0, 1, 0, 0U, 0, 0U, 0);
  c1_y = c1_d0;
  sf_mex_destroy(&c1_u);
  return c1_y;
}

static void c1_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c1_mxArrayInData, const char_T *c1_varName, void *c1_outData)
{
  const mxArray *c1_y;
  const char_T *c1_identifier;
  emlrtMsgIdentifier c1_thisId;
  real_T c1_b_y;
  SFc1_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc1_robulinkInstanceStruct *)chartInstanceVoid;
  c1_y = sf_mex_dup(c1_mxArrayInData);
  c1_identifier = c1_varName;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_b_y = c1_emlrt_marshallIn(chartInstance, sf_mex_dup(c1_y), &c1_thisId);
  sf_mex_destroy(&c1_y);
  *(real_T *)c1_outData = c1_b_y;
  sf_mex_destroy(&c1_mxArrayInData);
}

static const mxArray *c1_b_sf_marshallOut(void *chartInstanceVoid, void
  *c1_inData)
{
  const mxArray *c1_mxArrayOutData = NULL;
  int32_T c1_u;
  const mxArray *c1_y = NULL;
  SFc1_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc1_robulinkInstanceStruct *)chartInstanceVoid;
  c1_mxArrayOutData = NULL;
  c1_u = *(int32_T *)c1_inData;
  c1_y = NULL;
  sf_mex_assign(&c1_y, sf_mex_create("y", &c1_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c1_mxArrayOutData, c1_y, FALSE);
  return c1_mxArrayOutData;
}

static const mxArray *c1_c_sf_marshallOut(void *chartInstanceVoid, void
  *c1_inData)
{
  const mxArray *c1_mxArrayOutData = NULL;
  int32_T c1_i14;
  real_T c1_b_inData[3];
  int32_T c1_i15;
  real_T c1_u[3];
  const mxArray *c1_y = NULL;
  SFc1_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc1_robulinkInstanceStruct *)chartInstanceVoid;
  c1_mxArrayOutData = NULL;
  for (c1_i14 = 0; c1_i14 < 3; c1_i14++) {
    c1_b_inData[c1_i14] = (*(real_T (*)[3])c1_inData)[c1_i14];
  }

  for (c1_i15 = 0; c1_i15 < 3; c1_i15++) {
    c1_u[c1_i15] = c1_b_inData[c1_i15];
  }

  c1_y = NULL;
  sf_mex_assign(&c1_y, sf_mex_create("y", c1_u, 0, 0U, 1U, 0U, 1, 3), FALSE);
  sf_mex_assign(&c1_mxArrayOutData, c1_y, FALSE);
  return c1_mxArrayOutData;
}

static void c1_b_emlrt_marshallIn(SFc1_robulinkInstanceStruct *chartInstance,
  const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId, real_T c1_y[3])
{
  real_T c1_dv0[3];
  int32_T c1_i16;
  sf_mex_import(c1_parentId, sf_mex_dup(c1_u), c1_dv0, 1, 0, 0U, 1, 0U, 1, 3);
  for (c1_i16 = 0; c1_i16 < 3; c1_i16++) {
    c1_y[c1_i16] = c1_dv0[c1_i16];
  }

  sf_mex_destroy(&c1_u);
}

static void c1_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c1_mxArrayInData, const char_T *c1_varName, void *c1_outData)
{
  const mxArray *c1_update;
  const char_T *c1_identifier;
  emlrtMsgIdentifier c1_thisId;
  real_T c1_y[3];
  int32_T c1_i17;
  SFc1_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc1_robulinkInstanceStruct *)chartInstanceVoid;
  c1_update = sf_mex_dup(c1_mxArrayInData);
  c1_identifier = c1_varName;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c1_update), &c1_thisId, c1_y);
  sf_mex_destroy(&c1_update);
  for (c1_i17 = 0; c1_i17 < 3; c1_i17++) {
    (*(real_T (*)[3])c1_outData)[c1_i17] = c1_y[c1_i17];
  }

  sf_mex_destroy(&c1_mxArrayInData);
}

static const mxArray *c1_d_sf_marshallOut(void *chartInstanceVoid, void
  *c1_inData)
{
  const mxArray *c1_mxArrayOutData = NULL;
  int32_T c1_i18;
  int32_T c1_i19;
  int32_T c1_i20;
  real_T c1_b_inData[6];
  int32_T c1_i21;
  int32_T c1_i22;
  int32_T c1_i23;
  real_T c1_u[6];
  const mxArray *c1_y = NULL;
  SFc1_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc1_robulinkInstanceStruct *)chartInstanceVoid;
  c1_mxArrayOutData = NULL;
  c1_i18 = 0;
  for (c1_i19 = 0; c1_i19 < 2; c1_i19++) {
    for (c1_i20 = 0; c1_i20 < 3; c1_i20++) {
      c1_b_inData[c1_i20 + c1_i18] = (*(real_T (*)[6])c1_inData)[c1_i20 + c1_i18];
    }

    c1_i18 += 3;
  }

  c1_i21 = 0;
  for (c1_i22 = 0; c1_i22 < 2; c1_i22++) {
    for (c1_i23 = 0; c1_i23 < 3; c1_i23++) {
      c1_u[c1_i23 + c1_i21] = c1_b_inData[c1_i23 + c1_i21];
    }

    c1_i21 += 3;
  }

  c1_y = NULL;
  sf_mex_assign(&c1_y, sf_mex_create("y", c1_u, 0, 0U, 1U, 0U, 2, 3, 2), FALSE);
  sf_mex_assign(&c1_mxArrayOutData, c1_y, FALSE);
  return c1_mxArrayOutData;
}

static void c1_c_emlrt_marshallIn(SFc1_robulinkInstanceStruct *chartInstance,
  const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId, real_T c1_y[6])
{
  real_T c1_dv1[6];
  int32_T c1_i24;
  sf_mex_import(c1_parentId, sf_mex_dup(c1_u), c1_dv1, 1, 0, 0U, 1, 0U, 2, 3, 2);
  for (c1_i24 = 0; c1_i24 < 6; c1_i24++) {
    c1_y[c1_i24] = c1_dv1[c1_i24];
  }

  sf_mex_destroy(&c1_u);
}

static void c1_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c1_mxArrayInData, const char_T *c1_varName, void *c1_outData)
{
  const mxArray *c1_B;
  const char_T *c1_identifier;
  emlrtMsgIdentifier c1_thisId;
  real_T c1_y[6];
  int32_T c1_i25;
  int32_T c1_i26;
  int32_T c1_i27;
  SFc1_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc1_robulinkInstanceStruct *)chartInstanceVoid;
  c1_B = sf_mex_dup(c1_mxArrayInData);
  c1_identifier = c1_varName;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c1_B), &c1_thisId, c1_y);
  sf_mex_destroy(&c1_B);
  c1_i25 = 0;
  for (c1_i26 = 0; c1_i26 < 2; c1_i26++) {
    for (c1_i27 = 0; c1_i27 < 3; c1_i27++) {
      (*(real_T (*)[6])c1_outData)[c1_i27 + c1_i25] = c1_y[c1_i27 + c1_i25];
    }

    c1_i25 += 3;
  }

  sf_mex_destroy(&c1_mxArrayInData);
}

const mxArray *sf_c1_robulink_get_eml_resolved_functions_info(void)
{
  const mxArray *c1_nameCaptureInfo;
  c1_ResolvedFunctionInfo c1_info[30];
  const mxArray *c1_m0 = NULL;
  int32_T c1_i28;
  c1_ResolvedFunctionInfo *c1_r0;
  c1_nameCaptureInfo = NULL;
  c1_nameCaptureInfo = NULL;
  c1_info_helper(c1_info);
  sf_mex_assign(&c1_m0, sf_mex_createstruct("nameCaptureInfo", 1, 30), FALSE);
  for (c1_i28 = 0; c1_i28 < 30; c1_i28++) {
    c1_r0 = &c1_info[c1_i28];
    sf_mex_addfield(c1_m0, sf_mex_create("nameCaptureInfo", c1_r0->context, 15,
      0U, 0U, 0U, 2, 1, strlen(c1_r0->context)), "context", "nameCaptureInfo",
                    c1_i28);
    sf_mex_addfield(c1_m0, sf_mex_create("nameCaptureInfo", c1_r0->name, 15, 0U,
      0U, 0U, 2, 1, strlen(c1_r0->name)), "name", "nameCaptureInfo", c1_i28);
    sf_mex_addfield(c1_m0, sf_mex_create("nameCaptureInfo", c1_r0->dominantType,
      15, 0U, 0U, 0U, 2, 1, strlen(c1_r0->dominantType)), "dominantType",
                    "nameCaptureInfo", c1_i28);
    sf_mex_addfield(c1_m0, sf_mex_create("nameCaptureInfo", c1_r0->resolved, 15,
      0U, 0U, 0U, 2, 1, strlen(c1_r0->resolved)), "resolved", "nameCaptureInfo",
                    c1_i28);
    sf_mex_addfield(c1_m0, sf_mex_create("nameCaptureInfo", &c1_r0->fileTimeLo,
      7, 0U, 0U, 0U, 0), "fileTimeLo", "nameCaptureInfo", c1_i28);
    sf_mex_addfield(c1_m0, sf_mex_create("nameCaptureInfo", &c1_r0->fileTimeHi,
      7, 0U, 0U, 0U, 0), "fileTimeHi", "nameCaptureInfo", c1_i28);
    sf_mex_addfield(c1_m0, sf_mex_create("nameCaptureInfo", &c1_r0->mFileTimeLo,
      7, 0U, 0U, 0U, 0), "mFileTimeLo", "nameCaptureInfo", c1_i28);
    sf_mex_addfield(c1_m0, sf_mex_create("nameCaptureInfo", &c1_r0->mFileTimeHi,
      7, 0U, 0U, 0U, 0), "mFileTimeHi", "nameCaptureInfo", c1_i28);
  }

  sf_mex_assign(&c1_nameCaptureInfo, c1_m0, FALSE);
  sf_mex_emlrtNameCapturePostProcessR2012a(&c1_nameCaptureInfo);
  return c1_nameCaptureInfo;
}

static void c1_info_helper(c1_ResolvedFunctionInfo c1_info[30])
{
  c1_info[0].context = "";
  c1_info[0].name = "mrdivide";
  c1_info[0].dominantType = "double";
  c1_info[0].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c1_info[0].fileTimeLo = 1357973148U;
  c1_info[0].fileTimeHi = 0U;
  c1_info[0].mFileTimeLo = 1319751566U;
  c1_info[0].mFileTimeHi = 0U;
  c1_info[1].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c1_info[1].name = "rdivide";
  c1_info[1].dominantType = "double";
  c1_info[1].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c1_info[1].fileTimeLo = 1346531988U;
  c1_info[1].fileTimeHi = 0U;
  c1_info[1].mFileTimeLo = 0U;
  c1_info[1].mFileTimeHi = 0U;
  c1_info[2].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c1_info[2].name = "eml_scalexp_compatible";
  c1_info[2].dominantType = "double";
  c1_info[2].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_compatible.m";
  c1_info[2].fileTimeLo = 1286840396U;
  c1_info[2].fileTimeHi = 0U;
  c1_info[2].mFileTimeLo = 0U;
  c1_info[2].mFileTimeHi = 0U;
  c1_info[3].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c1_info[3].name = "eml_div";
  c1_info[3].dominantType = "double";
  c1_info[3].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_div.m";
  c1_info[3].fileTimeLo = 1313369410U;
  c1_info[3].fileTimeHi = 0U;
  c1_info[3].mFileTimeLo = 0U;
  c1_info[3].mFileTimeHi = 0U;
  c1_info[4].context = "";
  c1_info[4].name = "mtimes";
  c1_info[4].dominantType = "double";
  c1_info[4].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c1_info[4].fileTimeLo = 1289541292U;
  c1_info[4].fileTimeHi = 0U;
  c1_info[4].mFileTimeLo = 0U;
  c1_info[4].mFileTimeHi = 0U;
  c1_info[5].context = "";
  c1_info[5].name = "cosd";
  c1_info[5].dominantType = "double";
  c1_info[5].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/cosd.m";
  c1_info[5].fileTimeLo = 1343851972U;
  c1_info[5].fileTimeHi = 0U;
  c1_info[5].mFileTimeLo = 0U;
  c1_info[5].mFileTimeHi = 0U;
  c1_info[6].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/cosd.m";
  c1_info[6].name = "eml_scalar_cosd_and_sind";
  c1_info[6].dominantType = "double";
  c1_info[6].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_cosd_and_sind.m";
  c1_info[6].fileTimeLo = 1343851978U;
  c1_info[6].fileTimeHi = 0U;
  c1_info[6].mFileTimeLo = 0U;
  c1_info[6].mFileTimeHi = 0U;
  c1_info[7].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_cosd_and_sind.m";
  c1_info[7].name = "isfinite";
  c1_info[7].dominantType = "double";
  c1_info[7].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isfinite.m";
  c1_info[7].fileTimeLo = 1286840358U;
  c1_info[7].fileTimeHi = 0U;
  c1_info[7].mFileTimeLo = 0U;
  c1_info[7].mFileTimeHi = 0U;
  c1_info[8].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isfinite.m";
  c1_info[8].name = "isinf";
  c1_info[8].dominantType = "double";
  c1_info[8].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isinf.m";
  c1_info[8].fileTimeLo = 1286840360U;
  c1_info[8].fileTimeHi = 0U;
  c1_info[8].mFileTimeLo = 0U;
  c1_info[8].mFileTimeHi = 0U;
  c1_info[9].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isfinite.m";
  c1_info[9].name = "isnan";
  c1_info[9].dominantType = "double";
  c1_info[9].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isnan.m";
  c1_info[9].fileTimeLo = 1286840360U;
  c1_info[9].fileTimeHi = 0U;
  c1_info[9].mFileTimeLo = 0U;
  c1_info[9].mFileTimeHi = 0U;
  c1_info[10].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_cosd_and_sind.m";
  c1_info[10].name = "eml_guarded_nan";
  c1_info[10].dominantType = "char";
  c1_info[10].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_guarded_nan.m";
  c1_info[10].fileTimeLo = 1286840376U;
  c1_info[10].fileTimeHi = 0U;
  c1_info[10].mFileTimeLo = 0U;
  c1_info[10].mFileTimeHi = 0U;
  c1_info[11].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_guarded_nan.m";
  c1_info[11].name = "eml_is_float_class";
  c1_info[11].dominantType = "char";
  c1_info[11].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_is_float_class.m";
  c1_info[11].fileTimeLo = 1286840382U;
  c1_info[11].fileTimeHi = 0U;
  c1_info[11].mFileTimeLo = 0U;
  c1_info[11].mFileTimeHi = 0U;
  c1_info[12].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_cosd_and_sind.m";
  c1_info[12].name = "eml_scalar_rem90";
  c1_info[12].dominantType = "double";
  c1_info[12].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_rem90.m";
  c1_info[12].fileTimeLo = 1343851978U;
  c1_info[12].fileTimeHi = 0U;
  c1_info[12].mFileTimeLo = 0U;
  c1_info[12].mFileTimeHi = 0U;
  c1_info[13].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_rem90.m";
  c1_info[13].name = "mrdivide";
  c1_info[13].dominantType = "double";
  c1_info[13].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c1_info[13].fileTimeLo = 1357973148U;
  c1_info[13].fileTimeHi = 0U;
  c1_info[13].mFileTimeLo = 1319751566U;
  c1_info[13].mFileTimeHi = 0U;
  c1_info[14].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_rem90.m";
  c1_info[14].name = "rem";
  c1_info[14].dominantType = "double";
  c1_info[14].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/rem.m";
  c1_info[14].fileTimeLo = 1343851984U;
  c1_info[14].fileTimeHi = 0U;
  c1_info[14].mFileTimeLo = 0U;
  c1_info[14].mFileTimeHi = 0U;
  c1_info[15].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/rem.m";
  c1_info[15].name = "eml_scalar_eg";
  c1_info[15].dominantType = "double";
  c1_info[15].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c1_info[15].fileTimeLo = 1286840396U;
  c1_info[15].fileTimeHi = 0U;
  c1_info[15].mFileTimeLo = 0U;
  c1_info[15].mFileTimeHi = 0U;
  c1_info[16].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/rem.m";
  c1_info[16].name = "eml_scalexp_alloc";
  c1_info[16].dominantType = "double";
  c1_info[16].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_alloc.m";
  c1_info[16].fileTimeLo = 1352446460U;
  c1_info[16].fileTimeHi = 0U;
  c1_info[16].mFileTimeLo = 0U;
  c1_info[16].mFileTimeHi = 0U;
  c1_info[17].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_rem90.m";
  c1_info[17].name = "abs";
  c1_info[17].dominantType = "double";
  c1_info[17].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/abs.m";
  c1_info[17].fileTimeLo = 1343851966U;
  c1_info[17].fileTimeHi = 0U;
  c1_info[17].mFileTimeLo = 0U;
  c1_info[17].mFileTimeHi = 0U;
  c1_info[18].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/abs.m";
  c1_info[18].name = "eml_scalar_abs";
  c1_info[18].dominantType = "double";
  c1_info[18].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_abs.m";
  c1_info[18].fileTimeLo = 1286840312U;
  c1_info[18].fileTimeHi = 0U;
  c1_info[18].mFileTimeLo = 0U;
  c1_info[18].mFileTimeHi = 0U;
  c1_info[19].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_rem90.m";
  c1_info[19].name = "mtimes";
  c1_info[19].dominantType = "double";
  c1_info[19].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c1_info[19].fileTimeLo = 1289541292U;
  c1_info[19].fileTimeHi = 0U;
  c1_info[19].mFileTimeLo = 0U;
  c1_info[19].mFileTimeHi = 0U;
  c1_info[20].context = "";
  c1_info[20].name = "sind";
  c1_info[20].dominantType = "double";
  c1_info[20].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/sind.m";
  c1_info[20].fileTimeLo = 1343851986U;
  c1_info[20].fileTimeHi = 0U;
  c1_info[20].mFileTimeLo = 0U;
  c1_info[20].mFileTimeHi = 0U;
  c1_info[21].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/sind.m";
  c1_info[21].name = "eml_scalar_cosd_and_sind";
  c1_info[21].dominantType = "double";
  c1_info[21].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_cosd_and_sind.m";
  c1_info[21].fileTimeLo = 1343851978U;
  c1_info[21].fileTimeHi = 0U;
  c1_info[21].mFileTimeLo = 0U;
  c1_info[21].mFileTimeHi = 0U;
  c1_info[22].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c1_info[22].name = "eml_index_class";
  c1_info[22].dominantType = "";
  c1_info[22].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  c1_info[22].fileTimeLo = 1323192178U;
  c1_info[22].fileTimeHi = 0U;
  c1_info[22].mFileTimeLo = 0U;
  c1_info[22].mFileTimeHi = 0U;
  c1_info[23].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c1_info[23].name = "eml_scalar_eg";
  c1_info[23].dominantType = "double";
  c1_info[23].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c1_info[23].fileTimeLo = 1286840396U;
  c1_info[23].fileTimeHi = 0U;
  c1_info[23].mFileTimeLo = 0U;
  c1_info[23].mFileTimeHi = 0U;
  c1_info[24].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c1_info[24].name = "eml_xgemm";
  c1_info[24].dominantType = "char";
  c1_info[24].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/eml_xgemm.m";
  c1_info[24].fileTimeLo = 1299098372U;
  c1_info[24].fileTimeHi = 0U;
  c1_info[24].mFileTimeLo = 0U;
  c1_info[24].mFileTimeHi = 0U;
  c1_info[25].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/eml_xgemm.m";
  c1_info[25].name = "eml_blas_inline";
  c1_info[25].dominantType = "";
  c1_info[25].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/eml_blas_inline.m";
  c1_info[25].fileTimeLo = 1299098368U;
  c1_info[25].fileTimeHi = 0U;
  c1_info[25].mFileTimeLo = 0U;
  c1_info[25].mFileTimeHi = 0U;
  c1_info[26].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m!below_threshold";
  c1_info[26].name = "mtimes";
  c1_info[26].dominantType = "double";
  c1_info[26].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c1_info[26].fileTimeLo = 1289541292U;
  c1_info[26].fileTimeHi = 0U;
  c1_info[26].mFileTimeLo = 0U;
  c1_info[26].mFileTimeHi = 0U;
  c1_info[27].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m";
  c1_info[27].name = "eml_index_class";
  c1_info[27].dominantType = "";
  c1_info[27].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  c1_info[27].fileTimeLo = 1323192178U;
  c1_info[27].fileTimeHi = 0U;
  c1_info[27].mFileTimeLo = 0U;
  c1_info[27].mFileTimeHi = 0U;
  c1_info[28].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m";
  c1_info[28].name = "eml_scalar_eg";
  c1_info[28].dominantType = "double";
  c1_info[28].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c1_info[28].fileTimeLo = 1286840396U;
  c1_info[28].fileTimeHi = 0U;
  c1_info[28].mFileTimeLo = 0U;
  c1_info[28].mFileTimeHi = 0U;
  c1_info[29].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m";
  c1_info[29].name = "eml_refblas_xgemm";
  c1_info[29].dominantType = "char";
  c1_info[29].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/refblas/eml_refblas_xgemm.m";
  c1_info[29].fileTimeLo = 1299098374U;
  c1_info[29].fileTimeHi = 0U;
  c1_info[29].mFileTimeLo = 0U;
  c1_info[29].mFileTimeHi = 0U;
}

static real_T c1_cosd(SFc1_robulinkInstanceStruct *chartInstance, real_T c1_x)
{
  real_T c1_b_x;
  c1_b_x = c1_x;
  c1_b_cosd(chartInstance, &c1_b_x);
  return c1_b_x;
}

static real_T c1_sind(SFc1_robulinkInstanceStruct *chartInstance, real_T c1_x)
{
  real_T c1_b_x;
  c1_b_x = c1_x;
  c1_b_sind(chartInstance, &c1_b_x);
  return c1_b_x;
}

static void c1_eml_scalar_eg(SFc1_robulinkInstanceStruct *chartInstance)
{
}

static int32_T c1_d_emlrt_marshallIn(SFc1_robulinkInstanceStruct *chartInstance,
  const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId)
{
  int32_T c1_y;
  int32_T c1_i29;
  sf_mex_import(c1_parentId, sf_mex_dup(c1_u), &c1_i29, 1, 6, 0U, 0, 0U, 0);
  c1_y = c1_i29;
  sf_mex_destroy(&c1_u);
  return c1_y;
}

static void c1_d_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c1_mxArrayInData, const char_T *c1_varName, void *c1_outData)
{
  const mxArray *c1_b_sfEvent;
  const char_T *c1_identifier;
  emlrtMsgIdentifier c1_thisId;
  int32_T c1_y;
  SFc1_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc1_robulinkInstanceStruct *)chartInstanceVoid;
  c1_b_sfEvent = sf_mex_dup(c1_mxArrayInData);
  c1_identifier = c1_varName;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_y = c1_d_emlrt_marshallIn(chartInstance, sf_mex_dup(c1_b_sfEvent),
    &c1_thisId);
  sf_mex_destroy(&c1_b_sfEvent);
  *(int32_T *)c1_outData = c1_y;
  sf_mex_destroy(&c1_mxArrayInData);
}

static uint8_T c1_e_emlrt_marshallIn(SFc1_robulinkInstanceStruct *chartInstance,
  const mxArray *c1_b_is_active_c1_robulink, const char_T *c1_identifier)
{
  uint8_T c1_y;
  emlrtMsgIdentifier c1_thisId;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_y = c1_f_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c1_b_is_active_c1_robulink), &c1_thisId);
  sf_mex_destroy(&c1_b_is_active_c1_robulink);
  return c1_y;
}

static uint8_T c1_f_emlrt_marshallIn(SFc1_robulinkInstanceStruct *chartInstance,
  const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId)
{
  uint8_T c1_y;
  uint8_T c1_u0;
  sf_mex_import(c1_parentId, sf_mex_dup(c1_u), &c1_u0, 1, 3, 0U, 0, 0U, 0);
  c1_y = c1_u0;
  sf_mex_destroy(&c1_u);
  return c1_y;
}

static void c1_b_cosd(SFc1_robulinkInstanceStruct *chartInstance, real_T *c1_x)
{
  real_T c1_b_x;
  real_T c1_c_x;
  real_T c1_d_x;
  boolean_T c1_b;
  boolean_T c1_b0;
  real_T c1_e_x;
  boolean_T c1_b_b;
  boolean_T c1_b1;
  boolean_T c1_c_b;
  real_T c1_f_x;
  real_T c1_g_x;
  real_T c1_h_x;
  real_T c1_xk;
  real_T c1_i_x;
  real_T c1_j_x;
  real_T c1_absx;
  real_T c1_k_x;
  real_T c1_l_x;
  real_T c1_d_b;
  int8_T c1_n;
  real_T c1_e_b;
  real_T c1_f_b;
  real_T c1_g_b;
  real_T c1_h_b;
  int8_T c1_b_n;
  c1_b_x = *c1_x;
  c1_c_x = c1_b_x;
  c1_d_x = c1_c_x;
  c1_b = muDoubleScalarIsInf(c1_d_x);
  c1_b0 = !c1_b;
  c1_e_x = c1_c_x;
  c1_b_b = muDoubleScalarIsNaN(c1_e_x);
  c1_b1 = !c1_b_b;
  c1_c_b = (c1_b0 && c1_b1);
  if (!c1_c_b) {
    *c1_x = rtNaN;
  } else {
    c1_f_x = c1_b_x;
    c1_g_x = c1_f_x;
    c1_h_x = c1_g_x;
    c1_xk = c1_h_x;
    c1_g_x = muDoubleScalarRem(c1_xk, 360.0);
    c1_i_x = c1_g_x;
    c1_j_x = c1_i_x;
    c1_absx = muDoubleScalarAbs(c1_j_x);
    if (c1_absx > 180.0) {
      if (c1_g_x > 0.0) {
        c1_g_x -= 360.0;
      } else {
        c1_g_x += 360.0;
      }

      c1_k_x = c1_g_x;
      c1_l_x = c1_k_x;
      c1_absx = muDoubleScalarAbs(c1_l_x);
    }

    if (c1_absx <= 45.0) {
      c1_d_b = c1_g_x;
      c1_g_x = 0.017453292519943295 * c1_d_b;
      c1_n = 0;
    } else if (c1_absx <= 135.0) {
      if (c1_g_x > 0.0) {
        c1_e_b = c1_g_x - 90.0;
        c1_g_x = 0.017453292519943295 * c1_e_b;
        c1_n = 1;
      } else {
        c1_f_b = c1_g_x + 90.0;
        c1_g_x = 0.017453292519943295 * c1_f_b;
        c1_n = -1;
      }
    } else if (c1_g_x > 0.0) {
      c1_g_b = c1_g_x - 180.0;
      c1_g_x = 0.017453292519943295 * c1_g_b;
      c1_n = 2;
    } else {
      c1_h_b = c1_g_x + 180.0;
      c1_g_x = 0.017453292519943295 * c1_h_b;
      c1_n = -2;
    }

    c1_b_n = c1_n;
    c1_b_x = c1_g_x;
    if ((real_T)c1_b_n == 0.0) {
      *c1_x = muDoubleScalarCos(c1_b_x);
    } else if ((real_T)c1_b_n == 1.0) {
      *c1_x = -muDoubleScalarSin(c1_b_x);
    } else if ((real_T)c1_b_n == -1.0) {
      *c1_x = muDoubleScalarSin(c1_b_x);
    } else {
      *c1_x = -muDoubleScalarCos(c1_b_x);
    }
  }
}

static void c1_b_sind(SFc1_robulinkInstanceStruct *chartInstance, real_T *c1_x)
{
  real_T c1_b_x;
  real_T c1_c_x;
  real_T c1_d_x;
  boolean_T c1_b;
  boolean_T c1_b2;
  real_T c1_e_x;
  boolean_T c1_b_b;
  boolean_T c1_b3;
  boolean_T c1_c_b;
  real_T c1_d1;
  real_T c1_f_x;
  real_T c1_g_x;
  real_T c1_h_x;
  real_T c1_xk;
  real_T c1_i_x;
  real_T c1_j_x;
  real_T c1_absx;
  real_T c1_k_x;
  real_T c1_l_x;
  real_T c1_d_b;
  int8_T c1_n;
  real_T c1_e_b;
  real_T c1_f_b;
  real_T c1_g_b;
  real_T c1_h_b;
  int8_T c1_b_n;
  c1_b_x = *c1_x;
  c1_c_x = c1_b_x;
  c1_d_x = c1_c_x;
  c1_b = muDoubleScalarIsInf(c1_d_x);
  c1_b2 = !c1_b;
  c1_e_x = c1_c_x;
  c1_b_b = muDoubleScalarIsNaN(c1_e_x);
  c1_b3 = !c1_b_b;
  c1_c_b = (c1_b2 && c1_b3);
  if (!c1_c_b) {
    c1_d1 = rtNaN;
  } else {
    c1_f_x = c1_b_x;
    c1_g_x = c1_f_x;
    c1_h_x = c1_g_x;
    c1_xk = c1_h_x;
    c1_g_x = muDoubleScalarRem(c1_xk, 360.0);
    c1_i_x = c1_g_x;
    c1_j_x = c1_i_x;
    c1_absx = muDoubleScalarAbs(c1_j_x);
    if (c1_absx > 180.0) {
      if (c1_g_x > 0.0) {
        c1_g_x -= 360.0;
      } else {
        c1_g_x += 360.0;
      }

      c1_k_x = c1_g_x;
      c1_l_x = c1_k_x;
      c1_absx = muDoubleScalarAbs(c1_l_x);
    }

    if (c1_absx <= 45.0) {
      c1_d_b = c1_g_x;
      c1_g_x = 0.017453292519943295 * c1_d_b;
      c1_n = 0;
    } else if (c1_absx <= 135.0) {
      if (c1_g_x > 0.0) {
        c1_e_b = c1_g_x - 90.0;
        c1_g_x = 0.017453292519943295 * c1_e_b;
        c1_n = 1;
      } else {
        c1_f_b = c1_g_x + 90.0;
        c1_g_x = 0.017453292519943295 * c1_f_b;
        c1_n = -1;
      }
    } else if (c1_g_x > 0.0) {
      c1_g_b = c1_g_x - 180.0;
      c1_g_x = 0.017453292519943295 * c1_g_b;
      c1_n = 2;
    } else {
      c1_h_b = c1_g_x + 180.0;
      c1_g_x = 0.017453292519943295 * c1_h_b;
      c1_n = -2;
    }

    c1_b_n = c1_n;
    c1_b_x = c1_g_x;
    if ((real_T)c1_b_n == 0.0) {
      c1_d1 = muDoubleScalarSin(c1_b_x);
    } else if ((real_T)c1_b_n == 1.0) {
      c1_d1 = muDoubleScalarCos(c1_b_x);
    } else if ((real_T)c1_b_n == -1.0) {
      c1_d1 = -muDoubleScalarCos(c1_b_x);
    } else {
      c1_d1 = -muDoubleScalarSin(c1_b_x);
    }
  }

  *c1_x = c1_d1;
}

static real_T c1_get_theta(SFc1_robulinkInstanceStruct *chartInstance, uint32_T
  c1_b)
{
  ssReadFromDataStoreElement(chartInstance->S, 0, NULL, c1_b);
  if (chartInstance->c1_theta_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'theta\' (#30) in the initialization routine of the chart.\n");
  }

  return *chartInstance->c1_theta_address;
}

static void c1_set_theta(SFc1_robulinkInstanceStruct *chartInstance, uint32_T
  c1_b, real_T c1_c)
{
  ssWriteToDataStoreElement(chartInstance->S, 0, NULL, c1_b);
  if (chartInstance->c1_theta_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'theta\' (#30) in the initialization routine of the chart.\n");
  }

  *chartInstance->c1_theta_address = c1_c;
}

static real_T *c1_access_theta(SFc1_robulinkInstanceStruct *chartInstance,
  uint32_T c1_b)
{
  real_T *c1_c;
  ssReadFromDataStore(chartInstance->S, 0, NULL);
  if (chartInstance->c1_theta_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'theta\' (#30) in the initialization routine of the chart.\n");
  }

  c1_c = chartInstance->c1_theta_address;
  if (c1_b == 0) {
    ssWriteToDataStore(chartInstance->S, 0, NULL);
  }

  return c1_c;
}

static real_T c1_get_x(SFc1_robulinkInstanceStruct *chartInstance, uint32_T c1_b)
{
  ssReadFromDataStoreElement(chartInstance->S, 1, NULL, c1_b);
  if (chartInstance->c1_x_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'x\' (#28) in the initialization routine of the chart.\n");
  }

  return *chartInstance->c1_x_address;
}

static void c1_set_x(SFc1_robulinkInstanceStruct *chartInstance, uint32_T c1_b,
                     real_T c1_c)
{
  ssWriteToDataStoreElement(chartInstance->S, 1, NULL, c1_b);
  if (chartInstance->c1_x_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'x\' (#28) in the initialization routine of the chart.\n");
  }

  *chartInstance->c1_x_address = c1_c;
}

static real_T *c1_access_x(SFc1_robulinkInstanceStruct *chartInstance, uint32_T
  c1_b)
{
  real_T *c1_c;
  ssReadFromDataStore(chartInstance->S, 1, NULL);
  if (chartInstance->c1_x_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'x\' (#28) in the initialization routine of the chart.\n");
  }

  c1_c = chartInstance->c1_x_address;
  if (c1_b == 0) {
    ssWriteToDataStore(chartInstance->S, 1, NULL);
  }

  return c1_c;
}

static real_T c1_get_y(SFc1_robulinkInstanceStruct *chartInstance, uint32_T c1_b)
{
  ssReadFromDataStoreElement(chartInstance->S, 2, NULL, c1_b);
  if (chartInstance->c1_y_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'y\' (#29) in the initialization routine of the chart.\n");
  }

  return *chartInstance->c1_y_address;
}

static void c1_set_y(SFc1_robulinkInstanceStruct *chartInstance, uint32_T c1_b,
                     real_T c1_c)
{
  ssWriteToDataStoreElement(chartInstance->S, 2, NULL, c1_b);
  if (chartInstance->c1_y_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'y\' (#29) in the initialization routine of the chart.\n");
  }

  *chartInstance->c1_y_address = c1_c;
}

static real_T *c1_access_y(SFc1_robulinkInstanceStruct *chartInstance, uint32_T
  c1_b)
{
  real_T *c1_c;
  ssReadFromDataStore(chartInstance->S, 2, NULL);
  if (chartInstance->c1_y_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'y\' (#29) in the initialization routine of the chart.\n");
  }

  c1_c = chartInstance->c1_y_address;
  if (c1_b == 0) {
    ssWriteToDataStore(chartInstance->S, 2, NULL);
  }

  return c1_c;
}

static void init_dsm_address_info(SFc1_robulinkInstanceStruct *chartInstance)
{
  ssGetSFcnDataStoreNameAddrIdx(chartInstance->S, "theta", (void **)
    &chartInstance->c1_theta_address, &chartInstance->c1_theta_index);
  ssGetSFcnDataStoreNameAddrIdx(chartInstance->S, "x", (void **)
    &chartInstance->c1_x_address, &chartInstance->c1_x_index);
  ssGetSFcnDataStoreNameAddrIdx(chartInstance->S, "y", (void **)
    &chartInstance->c1_y_address, &chartInstance->c1_y_index);
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

void sf_c1_robulink_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3656683981U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(3060723271U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(3472554080U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(1311724814U);
}

mxArray *sf_c1_robulink_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("SSxq2ihTlVgtPD5OSUcx5E");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,2,3,dataFields);

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
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(8));
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
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(8));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,1,"type",mxType);
    }

    mxSetField(mxData,1,"complexity",mxCreateDoubleScalar(0));
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

mxArray *sf_c1_robulink_third_party_uses_info(void)
{
  mxArray * mxcell3p = mxCreateCellMatrix(1,0);
  return(mxcell3p);
}

static const mxArray *sf_get_sim_state_info_c1_robulink(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S'type','srcId','name','auxInfo'{{M[8],M[0],T\"is_active_c1_robulink\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 1, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c1_robulink_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc1_robulinkInstanceStruct *chartInstance;
    chartInstance = (SFc1_robulinkInstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (sfGlobalDebugInstanceStruct,
           _robulinkMachineNumber_,
           1,
           1,
           1,
           5,
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
          _SFD_SET_DATA_PROPS(0,1,1,0,"wheelEncoderL");
          _SFD_SET_DATA_PROPS(1,1,1,0,"wheelEncoderR");
          _SFD_SET_DATA_PROPS(2,11,0,0,"x");
          _SFD_SET_DATA_PROPS(3,11,0,0,"y");
          _SFD_SET_DATA_PROPS(4,11,0,0,"theta");
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
        _SFD_CV_INIT_EML(0,1,1,2,0,0,0,0,0,0,0);
        _SFD_CV_INIT_EML_FCN(0,0,"eML_blk_kernel",0,-1,1396);
        _SFD_CV_INIT_EML_IF(0,1,0,1295,1309,1343,1363);
        _SFD_CV_INIT_EML_IF(0,1,1,1343,1363,-1,1363);
        _SFD_TRANS_COV_WTS(0,0,0,1,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              1,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_INT32,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c1_b_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(1,SF_INT32,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c1_b_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(2,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c1_sf_marshallOut,(MexInFcnForType)c1_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(3,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c1_sf_marshallOut,(MexInFcnForType)c1_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(4,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c1_sf_marshallOut,(MexInFcnForType)c1_sf_marshallIn);

        {
          int32_T *c1_wheelEncoderL;
          int32_T *c1_wheelEncoderR;
          c1_wheelEncoderR = (int32_T *)ssGetInputPortSignal(chartInstance->S, 1);
          c1_wheelEncoderL = (int32_T *)ssGetInputPortSignal(chartInstance->S, 0);
          _SFD_SET_DATA_VALUE_PTR(0U, c1_wheelEncoderL);
          _SFD_SET_DATA_VALUE_PTR(1U, c1_wheelEncoderR);
          _SFD_SET_DATA_VALUE_PTR(2U, chartInstance->c1_x_address);
          _SFD_SET_DATA_VALUE_PTR(3U, chartInstance->c1_y_address);
          _SFD_SET_DATA_VALUE_PTR(4U, chartInstance->c1_theta_address);
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
  return "kSSPHmhTr8Q1AeamKGOFOB";
}

static void sf_opaque_initialize_c1_robulink(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc1_robulinkInstanceStruct*) chartInstanceVar)
    ->S,0);
  initialize_params_c1_robulink((SFc1_robulinkInstanceStruct*) chartInstanceVar);
  initialize_c1_robulink((SFc1_robulinkInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_enable_c1_robulink(void *chartInstanceVar)
{
  enable_c1_robulink((SFc1_robulinkInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_disable_c1_robulink(void *chartInstanceVar)
{
  disable_c1_robulink((SFc1_robulinkInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_gateway_c1_robulink(void *chartInstanceVar)
{
  sf_c1_robulink((SFc1_robulinkInstanceStruct*) chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c1_robulink(SimStruct* S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c1_robulink((SFc1_robulinkInstanceStruct*)
    chartInfo->chartInstance);         /* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c1_robulink();/* state var info */
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

extern void sf_internal_set_sim_state_c1_robulink(SimStruct* S, const mxArray
  *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c1_robulink();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c1_robulink((SFc1_robulinkInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c1_robulink(SimStruct* S)
{
  return sf_internal_get_sim_state_c1_robulink(S);
}

static void sf_opaque_set_sim_state_c1_robulink(SimStruct* S, const mxArray *st)
{
  sf_internal_set_sim_state_c1_robulink(S, st);
}

static void sf_opaque_terminate_c1_robulink(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc1_robulinkInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
      unload_robulink_optimization_info();
    }

    finalize_c1_robulink((SFc1_robulinkInstanceStruct*) chartInstanceVar);
    utFree((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc1_robulink((SFc1_robulinkInstanceStruct*) chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c1_robulink(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c1_robulink((SFc1_robulinkInstanceStruct*)
      (((ChartInfoStruct *)ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c1_robulink(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_robulink_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      1);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,1,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,1,
      "gatewayCannotBeInlinedMultipleTimes"));
    sf_update_buildInfo(S,sf_get_instance_specialization(),infoStruct,1);
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 1, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,1,2);
    }

    {
      unsigned int outPortIdx;
      for (outPortIdx=1; outPortIdx<=0; ++outPortIdx) {
        ssSetOutputPortOptimizeInIR(S, outPortIdx, 1U);
      }
    }

    {
      unsigned int inPortIdx;
      for (inPortIdx=0; inPortIdx < 2; ++inPortIdx) {
        ssSetInputPortOptimizeInIR(S, inPortIdx, 1U);
      }
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,1);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(3097115713U));
  ssSetChecksum1(S,(1015923980U));
  ssSetChecksum2(S,(1038514762U));
  ssSetChecksum3(S,(1053560734U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
  ssSupportsMultipleExecInstances(S,0);
}

static void mdlRTW_c1_robulink(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Embedded MATLAB");
  }
}

static void mdlStart_c1_robulink(SimStruct *S)
{
  SFc1_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc1_robulinkInstanceStruct *)utMalloc(sizeof
    (SFc1_robulinkInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc1_robulinkInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 1;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway = sf_opaque_gateway_c1_robulink;
  chartInstance->chartInfo.initializeChart = sf_opaque_initialize_c1_robulink;
  chartInstance->chartInfo.terminateChart = sf_opaque_terminate_c1_robulink;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c1_robulink;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c1_robulink;
  chartInstance->chartInfo.getSimState = sf_opaque_get_sim_state_c1_robulink;
  chartInstance->chartInfo.setSimState = sf_opaque_set_sim_state_c1_robulink;
  chartInstance->chartInfo.getSimStateInfo = sf_get_sim_state_info_c1_robulink;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c1_robulink;
  chartInstance->chartInfo.mdlStart = mdlStart_c1_robulink;
  chartInstance->chartInfo.mdlSetWorkWidths = mdlSetWorkWidths_c1_robulink;
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

void c1_robulink_method_dispatcher(SimStruct *S, int_T method, void *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c1_robulink(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c1_robulink(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c1_robulink(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c1_robulink_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}

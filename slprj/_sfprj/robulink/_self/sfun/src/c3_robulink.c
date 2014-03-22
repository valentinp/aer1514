/* Include files */

#include <stddef.h>
#include "blas.h"
#include "robulink_sfun.h"
#include "c3_robulink.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "robulink_sfun_debug_macros.h"
#define _SF_MEX_LISTEN_FOR_CTRL_C(S)   sf_mex_listen_for_ctrl_c(sfGlobalDebugInstanceStruct,S);

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)

/* Variable Declarations */

/* Variable Definitions */
static const char * c3_debug_family_names[8] = { "nargin", "nargout", "xDisp",
  "yDisp", "thetaDisp", "x", "y", "theta" };

/* Function Declarations */
static void initialize_c3_robulink(SFc3_robulinkInstanceStruct *chartInstance);
static void initialize_params_c3_robulink(SFc3_robulinkInstanceStruct
  *chartInstance);
static void enable_c3_robulink(SFc3_robulinkInstanceStruct *chartInstance);
static void disable_c3_robulink(SFc3_robulinkInstanceStruct *chartInstance);
static void c3_update_debugger_state_c3_robulink(SFc3_robulinkInstanceStruct
  *chartInstance);
static const mxArray *get_sim_state_c3_robulink(SFc3_robulinkInstanceStruct
  *chartInstance);
static void set_sim_state_c3_robulink(SFc3_robulinkInstanceStruct *chartInstance,
  const mxArray *c3_st);
static void finalize_c3_robulink(SFc3_robulinkInstanceStruct *chartInstance);
static void sf_c3_robulink(SFc3_robulinkInstanceStruct *chartInstance);
static void initSimStructsc3_robulink(SFc3_robulinkInstanceStruct *chartInstance);
static void registerMessagesc3_robulink(SFc3_robulinkInstanceStruct
  *chartInstance);
static void init_script_number_translation(uint32_T c3_machineNumber, uint32_T
  c3_chartNumber);
static const mxArray *c3_sf_marshallOut(void *chartInstanceVoid, void *c3_inData);
static real_T c3_emlrt_marshallIn(SFc3_robulinkInstanceStruct *chartInstance,
  const mxArray *c3_theta, const char_T *c3_identifier);
static real_T c3_b_emlrt_marshallIn(SFc3_robulinkInstanceStruct *chartInstance,
  const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId);
static void c3_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c3_mxArrayInData, const char_T *c3_varName, void *c3_outData);
static const mxArray *c3_b_sf_marshallOut(void *chartInstanceVoid, void
  *c3_inData);
static int32_T c3_c_emlrt_marshallIn(SFc3_robulinkInstanceStruct *chartInstance,
  const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId);
static void c3_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c3_mxArrayInData, const char_T *c3_varName, void *c3_outData);
static uint8_T c3_d_emlrt_marshallIn(SFc3_robulinkInstanceStruct *chartInstance,
  const mxArray *c3_b_is_active_c3_robulink, const char_T *c3_identifier);
static uint8_T c3_e_emlrt_marshallIn(SFc3_robulinkInstanceStruct *chartInstance,
  const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId);
static real_T c3_get_theta(SFc3_robulinkInstanceStruct *chartInstance, uint32_T
  c3_b);
static void c3_set_theta(SFc3_robulinkInstanceStruct *chartInstance, uint32_T
  c3_b, real_T c3_c);
static real_T *c3_access_theta(SFc3_robulinkInstanceStruct *chartInstance,
  uint32_T c3_b);
static real_T c3_get_x(SFc3_robulinkInstanceStruct *chartInstance, uint32_T c3_b);
static void c3_set_x(SFc3_robulinkInstanceStruct *chartInstance, uint32_T c3_b,
                     real_T c3_c);
static real_T *c3_access_x(SFc3_robulinkInstanceStruct *chartInstance, uint32_T
  c3_b);
static real_T c3_get_y(SFc3_robulinkInstanceStruct *chartInstance, uint32_T c3_b);
static void c3_set_y(SFc3_robulinkInstanceStruct *chartInstance, uint32_T c3_b,
                     real_T c3_c);
static real_T *c3_access_y(SFc3_robulinkInstanceStruct *chartInstance, uint32_T
  c3_b);
static void init_dsm_address_info(SFc3_robulinkInstanceStruct *chartInstance);

/* Function Definitions */
static void initialize_c3_robulink(SFc3_robulinkInstanceStruct *chartInstance)
{
  chartInstance->c3_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c3_is_active_c3_robulink = 0U;
}

static void initialize_params_c3_robulink(SFc3_robulinkInstanceStruct
  *chartInstance)
{
}

static void enable_c3_robulink(SFc3_robulinkInstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c3_robulink(SFc3_robulinkInstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void c3_update_debugger_state_c3_robulink(SFc3_robulinkInstanceStruct
  *chartInstance)
{
}

static const mxArray *get_sim_state_c3_robulink(SFc3_robulinkInstanceStruct
  *chartInstance)
{
  const mxArray *c3_st;
  const mxArray *c3_y = NULL;
  real_T c3_hoistedGlobal;
  real_T c3_u;
  const mxArray *c3_b_y = NULL;
  real_T c3_b_hoistedGlobal;
  real_T c3_b_u;
  const mxArray *c3_c_y = NULL;
  real_T c3_c_hoistedGlobal;
  real_T c3_c_u;
  const mxArray *c3_d_y = NULL;
  uint8_T c3_d_hoistedGlobal;
  uint8_T c3_d_u;
  const mxArray *c3_e_y = NULL;
  real_T *c3_thetaDisp;
  real_T *c3_xDisp;
  real_T *c3_yDisp;
  c3_thetaDisp = (real_T *)ssGetOutputPortSignal(chartInstance->S, 3);
  c3_yDisp = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c3_xDisp = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c3_st = NULL;
  c3_st = NULL;
  c3_y = NULL;
  sf_mex_assign(&c3_y, sf_mex_createcellarray(4), FALSE);
  c3_hoistedGlobal = *c3_thetaDisp;
  c3_u = c3_hoistedGlobal;
  c3_b_y = NULL;
  sf_mex_assign(&c3_b_y, sf_mex_create("y", &c3_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c3_y, 0, c3_b_y);
  c3_b_hoistedGlobal = *c3_xDisp;
  c3_b_u = c3_b_hoistedGlobal;
  c3_c_y = NULL;
  sf_mex_assign(&c3_c_y, sf_mex_create("y", &c3_b_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c3_y, 1, c3_c_y);
  c3_c_hoistedGlobal = *c3_yDisp;
  c3_c_u = c3_c_hoistedGlobal;
  c3_d_y = NULL;
  sf_mex_assign(&c3_d_y, sf_mex_create("y", &c3_c_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c3_y, 2, c3_d_y);
  c3_d_hoistedGlobal = chartInstance->c3_is_active_c3_robulink;
  c3_d_u = c3_d_hoistedGlobal;
  c3_e_y = NULL;
  sf_mex_assign(&c3_e_y, sf_mex_create("y", &c3_d_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c3_y, 3, c3_e_y);
  sf_mex_assign(&c3_st, c3_y, FALSE);
  return c3_st;
}

static void set_sim_state_c3_robulink(SFc3_robulinkInstanceStruct *chartInstance,
  const mxArray *c3_st)
{
  const mxArray *c3_u;
  real_T *c3_thetaDisp;
  real_T *c3_xDisp;
  real_T *c3_yDisp;
  c3_thetaDisp = (real_T *)ssGetOutputPortSignal(chartInstance->S, 3);
  c3_yDisp = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c3_xDisp = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  chartInstance->c3_doneDoubleBufferReInit = TRUE;
  c3_u = sf_mex_dup(c3_st);
  *c3_thetaDisp = c3_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell
    (c3_u, 0)), "thetaDisp");
  *c3_xDisp = c3_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c3_u,
    1)), "xDisp");
  *c3_yDisp = c3_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c3_u,
    2)), "yDisp");
  chartInstance->c3_is_active_c3_robulink = c3_d_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c3_u, 3)), "is_active_c3_robulink");
  sf_mex_destroy(&c3_u);
  c3_update_debugger_state_c3_robulink(chartInstance);
  sf_mex_destroy(&c3_st);
}

static void finalize_c3_robulink(SFc3_robulinkInstanceStruct *chartInstance)
{
}

static void sf_c3_robulink(SFc3_robulinkInstanceStruct *chartInstance)
{
  uint32_T c3_debug_family_var_map[8];
  real_T c3_nargin = 0.0;
  real_T c3_nargout = 3.0;
  real_T c3_xDisp;
  real_T c3_yDisp;
  real_T c3_thetaDisp;
  real_T *c3_b_xDisp;
  real_T *c3_b_yDisp;
  real_T *c3_b_thetaDisp;
  c3_b_thetaDisp = (real_T *)ssGetOutputPortSignal(chartInstance->S, 3);
  c3_b_yDisp = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c3_b_xDisp = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 2U, chartInstance->c3_sfEvent);
  _SFD_DATA_RANGE_CHECK(*c3_b_xDisp, 0U);
  _SFD_DATA_RANGE_CHECK(*c3_b_yDisp, 1U);
  _SFD_DATA_RANGE_CHECK(*c3_b_thetaDisp, 2U);
  chartInstance->c3_sfEvent = CALL_EVENT;
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 2U, chartInstance->c3_sfEvent);
  _SFD_SYMBOL_SCOPE_PUSH_EML(0U, 8U, 8U, c3_debug_family_names,
    c3_debug_family_var_map);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c3_nargin, 0U, c3_sf_marshallOut,
    c3_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c3_nargout, 1U, c3_sf_marshallOut,
    c3_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c3_xDisp, 2U, c3_sf_marshallOut,
    c3_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c3_yDisp, 3U, c3_sf_marshallOut,
    c3_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c3_thetaDisp, 4U, c3_sf_marshallOut,
    c3_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(chartInstance->c3_x_address, 5U,
    c3_sf_marshallOut, c3_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(chartInstance->c3_y_address, 6U,
    c3_sf_marshallOut, c3_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(chartInstance->c3_theta_address, 7U,
    c3_sf_marshallOut, c3_sf_marshallIn);
  CV_EML_FCN(0, 0);
  _SFD_EML_CALL(0U, chartInstance->c3_sfEvent, 2);
  _SFD_EML_CALL(0U, chartInstance->c3_sfEvent, 3);
  _SFD_EML_CALL(0U, chartInstance->c3_sfEvent, 4);
  _SFD_EML_CALL(0U, chartInstance->c3_sfEvent, 6);
  c3_xDisp = c3_get_x(chartInstance, 0);
  _SFD_EML_CALL(0U, chartInstance->c3_sfEvent, 7);
  c3_yDisp = c3_get_y(chartInstance, 0);
  _SFD_EML_CALL(0U, chartInstance->c3_sfEvent, 8);
  c3_thetaDisp = c3_get_theta(chartInstance, 0);
  _SFD_EML_CALL(0U, chartInstance->c3_sfEvent, -8);
  _SFD_SYMBOL_SCOPE_POP();
  *c3_b_xDisp = c3_xDisp;
  *c3_b_yDisp = c3_yDisp;
  *c3_b_thetaDisp = c3_thetaDisp;
  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 2U, chartInstance->c3_sfEvent);
  _SFD_CHECK_FOR_STATE_INCONSISTENCY(_robulinkMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void initSimStructsc3_robulink(SFc3_robulinkInstanceStruct *chartInstance)
{
}

static void registerMessagesc3_robulink(SFc3_robulinkInstanceStruct
  *chartInstance)
{
}

static void init_script_number_translation(uint32_T c3_machineNumber, uint32_T
  c3_chartNumber)
{
}

static const mxArray *c3_sf_marshallOut(void *chartInstanceVoid, void *c3_inData)
{
  const mxArray *c3_mxArrayOutData = NULL;
  real_T c3_u;
  const mxArray *c3_y = NULL;
  SFc3_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc3_robulinkInstanceStruct *)chartInstanceVoid;
  c3_mxArrayOutData = NULL;
  c3_u = *(real_T *)c3_inData;
  c3_y = NULL;
  sf_mex_assign(&c3_y, sf_mex_create("y", &c3_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c3_mxArrayOutData, c3_y, FALSE);
  return c3_mxArrayOutData;
}

static real_T c3_emlrt_marshallIn(SFc3_robulinkInstanceStruct *chartInstance,
  const mxArray *c3_theta, const char_T *c3_identifier)
{
  real_T c3_y;
  emlrtMsgIdentifier c3_thisId;
  c3_thisId.fIdentifier = c3_identifier;
  c3_thisId.fParent = NULL;
  c3_y = c3_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c3_theta), &c3_thisId);
  sf_mex_destroy(&c3_theta);
  return c3_y;
}

static real_T c3_b_emlrt_marshallIn(SFc3_robulinkInstanceStruct *chartInstance,
  const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId)
{
  real_T c3_y;
  real_T c3_d0;
  sf_mex_import(c3_parentId, sf_mex_dup(c3_u), &c3_d0, 1, 0, 0U, 0, 0U, 0);
  c3_y = c3_d0;
  sf_mex_destroy(&c3_u);
  return c3_y;
}

static void c3_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c3_mxArrayInData, const char_T *c3_varName, void *c3_outData)
{
  const mxArray *c3_theta;
  const char_T *c3_identifier;
  emlrtMsgIdentifier c3_thisId;
  real_T c3_y;
  SFc3_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc3_robulinkInstanceStruct *)chartInstanceVoid;
  c3_theta = sf_mex_dup(c3_mxArrayInData);
  c3_identifier = c3_varName;
  c3_thisId.fIdentifier = c3_identifier;
  c3_thisId.fParent = NULL;
  c3_y = c3_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c3_theta), &c3_thisId);
  sf_mex_destroy(&c3_theta);
  *(real_T *)c3_outData = c3_y;
  sf_mex_destroy(&c3_mxArrayInData);
}

const mxArray *sf_c3_robulink_get_eml_resolved_functions_info(void)
{
  const mxArray *c3_nameCaptureInfo = NULL;
  c3_nameCaptureInfo = NULL;
  sf_mex_assign(&c3_nameCaptureInfo, sf_mex_create("nameCaptureInfo", NULL, 0,
    0U, 1U, 0U, 2, 0, 1), FALSE);
  return c3_nameCaptureInfo;
}

static const mxArray *c3_b_sf_marshallOut(void *chartInstanceVoid, void
  *c3_inData)
{
  const mxArray *c3_mxArrayOutData = NULL;
  int32_T c3_u;
  const mxArray *c3_y = NULL;
  SFc3_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc3_robulinkInstanceStruct *)chartInstanceVoid;
  c3_mxArrayOutData = NULL;
  c3_u = *(int32_T *)c3_inData;
  c3_y = NULL;
  sf_mex_assign(&c3_y, sf_mex_create("y", &c3_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c3_mxArrayOutData, c3_y, FALSE);
  return c3_mxArrayOutData;
}

static int32_T c3_c_emlrt_marshallIn(SFc3_robulinkInstanceStruct *chartInstance,
  const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId)
{
  int32_T c3_y;
  int32_T c3_i0;
  sf_mex_import(c3_parentId, sf_mex_dup(c3_u), &c3_i0, 1, 6, 0U, 0, 0U, 0);
  c3_y = c3_i0;
  sf_mex_destroy(&c3_u);
  return c3_y;
}

static void c3_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c3_mxArrayInData, const char_T *c3_varName, void *c3_outData)
{
  const mxArray *c3_b_sfEvent;
  const char_T *c3_identifier;
  emlrtMsgIdentifier c3_thisId;
  int32_T c3_y;
  SFc3_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc3_robulinkInstanceStruct *)chartInstanceVoid;
  c3_b_sfEvent = sf_mex_dup(c3_mxArrayInData);
  c3_identifier = c3_varName;
  c3_thisId.fIdentifier = c3_identifier;
  c3_thisId.fParent = NULL;
  c3_y = c3_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c3_b_sfEvent),
    &c3_thisId);
  sf_mex_destroy(&c3_b_sfEvent);
  *(int32_T *)c3_outData = c3_y;
  sf_mex_destroy(&c3_mxArrayInData);
}

static uint8_T c3_d_emlrt_marshallIn(SFc3_robulinkInstanceStruct *chartInstance,
  const mxArray *c3_b_is_active_c3_robulink, const char_T *c3_identifier)
{
  uint8_T c3_y;
  emlrtMsgIdentifier c3_thisId;
  c3_thisId.fIdentifier = c3_identifier;
  c3_thisId.fParent = NULL;
  c3_y = c3_e_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c3_b_is_active_c3_robulink), &c3_thisId);
  sf_mex_destroy(&c3_b_is_active_c3_robulink);
  return c3_y;
}

static uint8_T c3_e_emlrt_marshallIn(SFc3_robulinkInstanceStruct *chartInstance,
  const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId)
{
  uint8_T c3_y;
  uint8_T c3_u0;
  sf_mex_import(c3_parentId, sf_mex_dup(c3_u), &c3_u0, 1, 3, 0U, 0, 0U, 0);
  c3_y = c3_u0;
  sf_mex_destroy(&c3_u);
  return c3_y;
}

static real_T c3_get_theta(SFc3_robulinkInstanceStruct *chartInstance, uint32_T
  c3_b)
{
  ssReadFromDataStoreElement(chartInstance->S, 0, NULL, c3_b);
  if (chartInstance->c3_theta_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'theta\' (#54) in the initialization routine of the chart.\n");
  }

  return *chartInstance->c3_theta_address;
}

static void c3_set_theta(SFc3_robulinkInstanceStruct *chartInstance, uint32_T
  c3_b, real_T c3_c)
{
  ssWriteToDataStoreElement(chartInstance->S, 0, NULL, c3_b);
  if (chartInstance->c3_theta_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'theta\' (#54) in the initialization routine of the chart.\n");
  }

  *chartInstance->c3_theta_address = c3_c;
}

static real_T *c3_access_theta(SFc3_robulinkInstanceStruct *chartInstance,
  uint32_T c3_b)
{
  real_T *c3_c;
  ssReadFromDataStore(chartInstance->S, 0, NULL);
  if (chartInstance->c3_theta_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'theta\' (#54) in the initialization routine of the chart.\n");
  }

  c3_c = chartInstance->c3_theta_address;
  if (c3_b == 0) {
    ssWriteToDataStore(chartInstance->S, 0, NULL);
  }

  return c3_c;
}

static real_T c3_get_x(SFc3_robulinkInstanceStruct *chartInstance, uint32_T c3_b)
{
  ssReadFromDataStoreElement(chartInstance->S, 1, NULL, c3_b);
  if (chartInstance->c3_x_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'x\' (#52) in the initialization routine of the chart.\n");
  }

  return *chartInstance->c3_x_address;
}

static void c3_set_x(SFc3_robulinkInstanceStruct *chartInstance, uint32_T c3_b,
                     real_T c3_c)
{
  ssWriteToDataStoreElement(chartInstance->S, 1, NULL, c3_b);
  if (chartInstance->c3_x_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'x\' (#52) in the initialization routine of the chart.\n");
  }

  *chartInstance->c3_x_address = c3_c;
}

static real_T *c3_access_x(SFc3_robulinkInstanceStruct *chartInstance, uint32_T
  c3_b)
{
  real_T *c3_c;
  ssReadFromDataStore(chartInstance->S, 1, NULL);
  if (chartInstance->c3_x_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'x\' (#52) in the initialization routine of the chart.\n");
  }

  c3_c = chartInstance->c3_x_address;
  if (c3_b == 0) {
    ssWriteToDataStore(chartInstance->S, 1, NULL);
  }

  return c3_c;
}

static real_T c3_get_y(SFc3_robulinkInstanceStruct *chartInstance, uint32_T c3_b)
{
  ssReadFromDataStoreElement(chartInstance->S, 2, NULL, c3_b);
  if (chartInstance->c3_y_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'y\' (#53) in the initialization routine of the chart.\n");
  }

  return *chartInstance->c3_y_address;
}

static void c3_set_y(SFc3_robulinkInstanceStruct *chartInstance, uint32_T c3_b,
                     real_T c3_c)
{
  ssWriteToDataStoreElement(chartInstance->S, 2, NULL, c3_b);
  if (chartInstance->c3_y_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'y\' (#53) in the initialization routine of the chart.\n");
  }

  *chartInstance->c3_y_address = c3_c;
}

static real_T *c3_access_y(SFc3_robulinkInstanceStruct *chartInstance, uint32_T
  c3_b)
{
  real_T *c3_c;
  ssReadFromDataStore(chartInstance->S, 2, NULL);
  if (chartInstance->c3_y_address == 0) {
    sf_mex_error_message("Invalid access to Data Store Memory data \'y\' (#53) in the initialization routine of the chart.\n");
  }

  c3_c = chartInstance->c3_y_address;
  if (c3_b == 0) {
    ssWriteToDataStore(chartInstance->S, 2, NULL);
  }

  return c3_c;
}

static void init_dsm_address_info(SFc3_robulinkInstanceStruct *chartInstance)
{
  ssGetSFcnDataStoreNameAddrIdx(chartInstance->S, "theta", (void **)
    &chartInstance->c3_theta_address, &chartInstance->c3_theta_index);
  ssGetSFcnDataStoreNameAddrIdx(chartInstance->S, "x", (void **)
    &chartInstance->c3_x_address, &chartInstance->c3_x_index);
  ssGetSFcnDataStoreNameAddrIdx(chartInstance->S, "y", (void **)
    &chartInstance->c3_y_address, &chartInstance->c3_y_index);
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

void sf_c3_robulink_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(891115211U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(2340428798U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(3348107011U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(2851823942U);
}

mxArray *sf_c3_robulink_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("xsFqZa2M9m3VFIw4AADEUF");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"inputs",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"parameters",mxCreateDoubleMatrix(0,0,
                mxREAL));
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,3,3,dataFields);

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
    mxSetField(mxAutoinheritanceInfo,0,"outputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"locals",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  return(mxAutoinheritanceInfo);
}

mxArray *sf_c3_robulink_third_party_uses_info(void)
{
  mxArray * mxcell3p = mxCreateCellMatrix(1,0);
  return(mxcell3p);
}

static const mxArray *sf_get_sim_state_info_c3_robulink(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x4'type','srcId','name','auxInfo'{{M[1],M[7],T\"thetaDisp\",},{M[1],M[5],T\"xDisp\",},{M[1],M[6],T\"yDisp\",},{M[8],M[0],T\"is_active_c3_robulink\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 4, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c3_robulink_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc3_robulinkInstanceStruct *chartInstance;
    chartInstance = (SFc3_robulinkInstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (sfGlobalDebugInstanceStruct,
           _robulinkMachineNumber_,
           3,
           1,
           1,
           6,
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
          _SFD_SET_DATA_PROPS(0,2,0,1,"xDisp");
          _SFD_SET_DATA_PROPS(1,2,0,1,"yDisp");
          _SFD_SET_DATA_PROPS(2,2,0,1,"thetaDisp");
          _SFD_SET_DATA_PROPS(3,11,0,0,"x");
          _SFD_SET_DATA_PROPS(4,11,0,0,"y");
          _SFD_SET_DATA_PROPS(5,11,0,0,"theta");
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
        _SFD_CV_INIT_EML(0,1,1,0,0,0,0,0,0,0,0);
        _SFD_CV_INIT_EML_FCN(0,0,"eML_blk_kernel",0,-1,155);
        _SFD_TRANS_COV_WTS(0,0,0,1,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              1,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c3_sf_marshallOut,(MexInFcnForType)c3_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(1,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c3_sf_marshallOut,(MexInFcnForType)c3_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(2,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c3_sf_marshallOut,(MexInFcnForType)c3_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(3,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c3_sf_marshallOut,(MexInFcnForType)c3_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(4,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c3_sf_marshallOut,(MexInFcnForType)c3_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(5,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c3_sf_marshallOut,(MexInFcnForType)c3_sf_marshallIn);

        {
          real_T *c3_xDisp;
          real_T *c3_yDisp;
          real_T *c3_thetaDisp;
          c3_thetaDisp = (real_T *)ssGetOutputPortSignal(chartInstance->S, 3);
          c3_yDisp = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
          c3_xDisp = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
          _SFD_SET_DATA_VALUE_PTR(0U, c3_xDisp);
          _SFD_SET_DATA_VALUE_PTR(1U, c3_yDisp);
          _SFD_SET_DATA_VALUE_PTR(2U, c3_thetaDisp);
          _SFD_SET_DATA_VALUE_PTR(3U, chartInstance->c3_x_address);
          _SFD_SET_DATA_VALUE_PTR(4U, chartInstance->c3_y_address);
          _SFD_SET_DATA_VALUE_PTR(5U, chartInstance->c3_theta_address);
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
  return "g4en6cRfE6dvN6BGxnpdK";
}

static void sf_opaque_initialize_c3_robulink(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc3_robulinkInstanceStruct*) chartInstanceVar)
    ->S,0);
  initialize_params_c3_robulink((SFc3_robulinkInstanceStruct*) chartInstanceVar);
  initialize_c3_robulink((SFc3_robulinkInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_enable_c3_robulink(void *chartInstanceVar)
{
  enable_c3_robulink((SFc3_robulinkInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_disable_c3_robulink(void *chartInstanceVar)
{
  disable_c3_robulink((SFc3_robulinkInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_gateway_c3_robulink(void *chartInstanceVar)
{
  sf_c3_robulink((SFc3_robulinkInstanceStruct*) chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c3_robulink(SimStruct* S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c3_robulink((SFc3_robulinkInstanceStruct*)
    chartInfo->chartInstance);         /* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c3_robulink();/* state var info */
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

extern void sf_internal_set_sim_state_c3_robulink(SimStruct* S, const mxArray
  *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c3_robulink();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c3_robulink((SFc3_robulinkInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c3_robulink(SimStruct* S)
{
  return sf_internal_get_sim_state_c3_robulink(S);
}

static void sf_opaque_set_sim_state_c3_robulink(SimStruct* S, const mxArray *st)
{
  sf_internal_set_sim_state_c3_robulink(S, st);
}

static void sf_opaque_terminate_c3_robulink(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc3_robulinkInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
      unload_robulink_optimization_info();
    }

    finalize_c3_robulink((SFc3_robulinkInstanceStruct*) chartInstanceVar);
    utFree((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc3_robulink((SFc3_robulinkInstanceStruct*) chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c3_robulink(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c3_robulink((SFc3_robulinkInstanceStruct*)
      (((ChartInfoStruct *)ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c3_robulink(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_robulink_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      3);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,3,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,3,
      "gatewayCannotBeInlinedMultipleTimes"));
    sf_update_buildInfo(S,sf_get_instance_specialization(),infoStruct,3);
    if (chartIsInlinable) {
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,3,3);
    }

    {
      unsigned int outPortIdx;
      for (outPortIdx=1; outPortIdx<=3; ++outPortIdx) {
        ssSetOutputPortOptimizeInIR(S, outPortIdx, 1U);
      }
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,3);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(3245058310U));
  ssSetChecksum1(S,(1731690046U));
  ssSetChecksum2(S,(391903027U));
  ssSetChecksum3(S,(1052032863U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
  ssSupportsMultipleExecInstances(S,0);
}

static void mdlRTW_c3_robulink(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Embedded MATLAB");
  }
}

static void mdlStart_c3_robulink(SimStruct *S)
{
  SFc3_robulinkInstanceStruct *chartInstance;
  chartInstance = (SFc3_robulinkInstanceStruct *)utMalloc(sizeof
    (SFc3_robulinkInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc3_robulinkInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 1;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway = sf_opaque_gateway_c3_robulink;
  chartInstance->chartInfo.initializeChart = sf_opaque_initialize_c3_robulink;
  chartInstance->chartInfo.terminateChart = sf_opaque_terminate_c3_robulink;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c3_robulink;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c3_robulink;
  chartInstance->chartInfo.getSimState = sf_opaque_get_sim_state_c3_robulink;
  chartInstance->chartInfo.setSimState = sf_opaque_set_sim_state_c3_robulink;
  chartInstance->chartInfo.getSimStateInfo = sf_get_sim_state_info_c3_robulink;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c3_robulink;
  chartInstance->chartInfo.mdlStart = mdlStart_c3_robulink;
  chartInstance->chartInfo.mdlSetWorkWidths = mdlSetWorkWidths_c3_robulink;
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

void c3_robulink_method_dispatcher(SimStruct *S, int_T method, void *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c3_robulink(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c3_robulink(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c3_robulink(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c3_robulink_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}

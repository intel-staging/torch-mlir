// RUN: torch-mlir-opt <%s --split-input-file -convert-torch-onnx-to-torch | FileCheck %s
// Generally, the test cases accumulated here come from running the importer
// over all included backend tests that involve simple ops with no model
// level constants. This is a pragmatic choice which lets us have a lot
// of tests in this file, whereas the others tend to be more bespoke.

// CHECK-LABEL: func.func @test_reciprocal
func.func @test_reciprocal(%arg0: !torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: torch.aten.reciprocal %arg0 : !torch.vtensor<[3,4,5],f32> -> !torch.vtensor<[3,4,5],f32>
  %0 = torch.operator "onnx.Reciprocal"(%arg0) : (!torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32>
  return %0 : !torch.vtensor<[3,4,5],f32>
}

// CHECK-LABEL: func.func @test_relu
func.func @test_relu(%arg0: !torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 14 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: torch.aten.relu %arg0 : !torch.vtensor<[3,4,5],f32> -> !torch.vtensor<[3,4,5],f32>
  %0 = torch.operator "onnx.Relu"(%arg0) : (!torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32>
  return %0 : !torch.vtensor<[3,4,5],f32>
}

// CHECK-LABEL: func.func @test_round
func.func @test_round(%arg0: !torch.vtensor<[15],f32>) -> !torch.vtensor<[15],f32> attributes {torch.onnx_meta.ir_version = 6 : si64, torch.onnx_meta.opset_version = 11 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  //CHECK: torch.aten.round %arg0 : !torch.vtensor<[15],f32> -> !torch.vtensor<[15],f32>
  %0 = torch.operator "onnx.Round"(%arg0) : (!torch.vtensor<[15],f32>) -> !torch.vtensor<[15],f32>
  return %0 : !torch.vtensor<[15],f32>
}

// CHECK-LABEL: func.func @test_scatter_elements_with_axis
func.func @test_scatter_elements_with_axis(%arg0: !torch.vtensor<[1,5],f32>, %arg1: !torch.vtensor<[1,2],si64>, %arg2: !torch.vtensor<[1,2],f32>) -> !torch.vtensor<[1,5],f32> attributes {torch.onnx_meta.ir_version = 8 : si64, torch.onnx_meta.opset_version = 18 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT1:.*]] = torch.constant.int 1
  // CHECK: torch.aten.scatter.src %arg0, %int1, %arg1, %arg2 : !torch.vtensor<[1,5],f32>, !torch.int, !torch.vtensor<[1,2],si64>, !torch.vtensor<[1,2],f32> -> !torch.vtensor<[1,5],f32>
  %0 = torch.operator "onnx.ScatterElements"(%arg0, %arg1, %arg2) {torch.onnx.axis = 1 : si64} : (!torch.vtensor<[1,5],f32>, !torch.vtensor<[1,2],si64>, !torch.vtensor<[1,2],f32>) -> !torch.vtensor<[1,5],f32>
  return %0 : !torch.vtensor<[1,5],f32>
}

// CHECK-LABEL: func.func @test_scatter_elements_with_duplicate_indices
func.func @test_scatter_elements_with_duplicate_indices(%arg0: !torch.vtensor<[1,5],f32>, %arg1: !torch.vtensor<[1,2],si64>, %arg2: !torch.vtensor<[1,2],f32>) -> !torch.vtensor<[1,5],f32> attributes {torch.onnx_meta.ir_version = 8 : si64, torch.onnx_meta.opset_version = 18 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT1:.*]] = torch.constant.int 1
  // CHECK: %[[STR:.*]] = torch.constant.str "add"
  // CHECK: torch.aten.scatter.reduce %arg0, %int1, %arg1, %arg2, %str : !torch.vtensor<[1,5],f32>, !torch.int, !torch.vtensor<[1,2],si64>, !torch.vtensor<[1,2],f32>, !torch.str -> !torch.vtensor<[1,5],f32>
  %0 = torch.operator "onnx.ScatterElements"(%arg0, %arg1, %arg2) {torch.onnx.axis = 1 : si64, torch.onnx.reduction = "add"} : (!torch.vtensor<[1,5],f32>, !torch.vtensor<[1,2],si64>, !torch.vtensor<[1,2],f32>) -> !torch.vtensor<[1,5],f32>
  return %0 : !torch.vtensor<[1,5],f32>
}

// CHECK-LABEL: func.func @test_scatter_elements_without_axis
func.func @test_scatter_elements_without_axis(%arg0: !torch.vtensor<[3,3],f32>, %arg1: !torch.vtensor<[2,3],si64>, %arg2: !torch.vtensor<[2,3],f32>) -> !torch.vtensor<[3,3],f32> attributes {torch.onnx_meta.ir_version = 8 : si64, torch.onnx_meta.opset_version = 18 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT0:.*]] = torch.constant.int 0
  // CHECK: torch.aten.scatter.src %arg0, %int0, %arg1, %arg2 : !torch.vtensor<[3,3],f32>, !torch.int, !torch.vtensor<[2,3],si64>, !torch.vtensor<[2,3],f32> -> !torch.vtensor<[3,3],f32>
  %0 = torch.operator "onnx.ScatterElements"(%arg0, %arg1, %arg2) : (!torch.vtensor<[3,3],f32>, !torch.vtensor<[2,3],si64>, !torch.vtensor<[2,3],f32>) -> !torch.vtensor<[3,3],f32>
  return %0 : !torch.vtensor<[3,3],f32>
}

// CHECK-LABEL: func.func @test_scatter_elements_with_reduction_mul
func.func @test_scatter_elements_with_reduction_mul(%arg0: !torch.vtensor<[1,5],f32>, %arg1: !torch.vtensor<[1,2],si64>, %arg2: !torch.vtensor<[1,2],f32>) -> !torch.vtensor<[1,5],f32> attributes {torch.onnx_meta.ir_version = 8 : si64, torch.onnx_meta.opset_version = 18 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT1:.*]] = torch.constant.int 1
  // CHECK: %[[STR:.*]] = torch.constant.str "multiply"
  // CHECK: torch.aten.scatter.reduce %arg0, %int1, %arg1, %arg2, %str : !torch.vtensor<[1,5],f32>, !torch.int, !torch.vtensor<[1,2],si64>, !torch.vtensor<[1,2],f32>, !torch.str -> !torch.vtensor<[1,5],f32>
  %0 = torch.operator "onnx.ScatterElements"(%arg0, %arg1, %arg2) {torch.onnx.axis = 1 : si64, torch.onnx.reduction = "mul"} : (!torch.vtensor<[1,5],f32>, !torch.vtensor<[1,2],si64>, !torch.vtensor<[1,2],f32>) -> !torch.vtensor<[1,5],f32>
  return %0 : !torch.vtensor<[1,5],f32>
}

// CHECK-LABEL: func.func @test_sigmoid_example
func.func @test_sigmoid_example(%arg0: !torch.vtensor<[3],f32>) -> !torch.vtensor<[3],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: torch.aten.sigmoid %arg0 : !torch.vtensor<[3],f32> -> !torch.vtensor<[3],f32>
  %0 = torch.operator "onnx.Sigmoid"(%arg0) : (!torch.vtensor<[3],f32>) -> !torch.vtensor<[3],f32>
  return %0 : !torch.vtensor<[3],f32>
}

// CHECK-LABEL: func.func @test_sin_example
func.func @test_sin_example(%arg0: !torch.vtensor<[3],f32>) -> !torch.vtensor<[3],f32> attributes {torch.onnx_meta.ir_version = 3 : si64, torch.onnx_meta.opset_version = 7 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: torch.aten.sin %arg0 : !torch.vtensor<[3],f32> -> !torch.vtensor<[3],f32>
  %0 = torch.operator "onnx.Sin"(%arg0) : (!torch.vtensor<[3],f32>) -> !torch.vtensor<[3],f32>
  return %0 : !torch.vtensor<[3],f32>
}

// CHECK-LABEL: func.func @test_tanh_example
func.func @test_tanh_example(%arg0: !torch.vtensor<[3],f32>) -> !torch.vtensor<[3],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: torch.aten.tanh %arg0 : !torch.vtensor<[3],f32> -> !torch.vtensor<[3],f32>
  %0 = torch.operator "onnx.Tanh"(%arg0) : (!torch.vtensor<[3],f32>) -> !torch.vtensor<[3],f32>
  return %0 : !torch.vtensor<[3],f32>
}

// CHECK-LABEL: func.func @test_sqrt_example
func.func @test_sqrt_example(%arg0: !torch.vtensor<[3],f32>) -> !torch.vtensor<[3],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: torch.aten.sqrt %arg0 : !torch.vtensor<[3],f32> -> !torch.vtensor<[3],f32>
  %0 = torch.operator "onnx.Sqrt"(%arg0) : (!torch.vtensor<[3],f32>) -> !torch.vtensor<[3],f32>
  return %0 : !torch.vtensor<[3],f32>
}

// CHECK-LABEL: func.func @test_sub_bcast
func.func @test_sub_bcast(%arg0: !torch.vtensor<[3,4,5],f32>, %arg1: !torch.vtensor<[5],f32>) -> !torch.vtensor<[3,4,5],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 14 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT1:.*]] = torch.constant.int 1
  // CHECK: torch.aten.sub.Tensor %arg0, %arg1, %int1 : !torch.vtensor<[3,4,5],f32>, !torch.vtensor<[5],f32>, !torch.int -> !torch.vtensor<[3,4,5],f32>
  %0 = torch.operator "onnx.Sub"(%arg0, %arg1) : (!torch.vtensor<[3,4,5],f32>, !torch.vtensor<[5],f32>) -> !torch.vtensor<[3,4,5],f32>
  return %0 : !torch.vtensor<[3,4,5],f32>
}

// CHECK-LABEL: func.func @test_sub_example
func.func @test_sub_example(%arg0: !torch.vtensor<[3],f32>, %arg1: !torch.vtensor<[3],f32>) -> !torch.vtensor<[3],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 14 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT1:.*]] = torch.constant.int 1
  // CHECK: torch.aten.sub.Tensor %arg0, %arg1, %int1 : !torch.vtensor<[3],f32>, !torch.vtensor<[3],f32>, !torch.int -> !torch.vtensor<[3],f32>
  %0 = torch.operator "onnx.Sub"(%arg0, %arg1) : (!torch.vtensor<[3],f32>, !torch.vtensor<[3],f32>) -> !torch.vtensor<[3],f32>
  return %0 : !torch.vtensor<[3],f32>
}

// CHECK-LABEL: func.func @test_sub
func.func @test_sub(%arg0: !torch.vtensor<[3,4,5],f32>, %arg1: !torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 14 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT1:.*]] = torch.constant.int 1
  // CHECK: torch.aten.sub.Tensor %arg0, %arg1, %int1 : !torch.vtensor<[3,4,5],f32>, !torch.vtensor<[3,4,5],f32>, !torch.int -> !torch.vtensor<[3,4,5],f32>
  %0 = torch.operator "onnx.Sub"(%arg0, %arg1) : (!torch.vtensor<[3,4,5],f32>, !torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32>
  return %0 : !torch.vtensor<[3,4,5],f32>
}

// CHECK-LABEL: func.func @test_sub_uint8
func.func @test_sub_uint8(%arg0: !torch.vtensor<[3,4,5],ui8>, %arg1: !torch.vtensor<[3,4,5],ui8>) -> !torch.vtensor<[3,4,5],ui8> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 14 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT1:.*]] = torch.constant.int 1
  // CHECK: torch.aten.sub.Tensor %arg0, %arg1, %int1 : !torch.vtensor<[3,4,5],ui8>, !torch.vtensor<[3,4,5],ui8>, !torch.int -> !torch.vtensor<[3,4,5],ui8>
  %0 = torch.operator "onnx.Sub"(%arg0, %arg1) : (!torch.vtensor<[3,4,5],ui8>, !torch.vtensor<[3,4,5],ui8>) -> !torch.vtensor<[3,4,5],ui8>
  return %0 : !torch.vtensor<[3,4,5],ui8>
}

// CHECK-LABEL: func.func @test_sum_example
func.func @test_sum_example(%arg0: !torch.vtensor<[3],f32>, %arg1: !torch.vtensor<[3],f32>, %arg2: !torch.vtensor<[3],f32>, %arg3: !torch.vtensor<[3],f32>) -> !torch.vtensor<[3],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT1:.*]] = torch.constant.int 1
  // CHECK: torch.aten.add.Tensor %arg0, %arg1, %int1 : !torch.vtensor<[3],f32>, !torch.vtensor<[3],f32>, !torch.int -> !torch.vtensor<[3],f32>
  // CHECK: torch.aten.add.Tensor %0, %arg2, %int1 : !torch.vtensor<[3],f32>, !torch.vtensor<[3],f32>, !torch.int -> !torch.vtensor
  // CHECK: torch.aten.add.Tensor %1, %arg3, %int1 : !torch.vtensor, !torch.vtensor<[3],f32>, !torch.int -> !torch.vtensor<[3],f32>
  %0 = torch.operator "onnx.Sum"(%arg0, %arg1, %arg2, %arg3) : (!torch.vtensor<[3],f32>, !torch.vtensor<[3],f32>, !torch.vtensor<[3],f32>, !torch.vtensor<[3],f32>) -> !torch.vtensor<[3],f32>
  return %0 : !torch.vtensor<[3],f32>
}

// CHECK-LABEL: func.func @test_sum_one_input
func.func @test_sum_one_input(%arg0: !torch.vtensor<[3],f32>) -> !torch.vtensor<[3],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  %0 = torch.operator "onnx.Sum"(%arg0) : (!torch.vtensor<[3],f32>) -> !torch.vtensor<[3],f32>
  return %0 : !torch.vtensor<[3],f32>
}

// CHECK-LABEL: func.func @test_sum_two_inputs
func.func @test_sum_two_inputs(%arg0: !torch.vtensor<[3],f32>, %arg1: !torch.vtensor<[3],f32>) -> !torch.vtensor<[3],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT1:.*]] = torch.constant.int 1
  // CHECK: torch.aten.add.Tensor %arg0, %arg1, %int1 : !torch.vtensor<[3],f32>, !torch.vtensor<[3],f32>, !torch.int -> !torch.vtensor<[3],f32>
  %0 = torch.operator "onnx.Sum"(%arg0, %arg1) : (!torch.vtensor<[3],f32>, !torch.vtensor<[3],f32>) -> !torch.vtensor<[3],f32>
  return %0 : !torch.vtensor<[3],f32>
}

// CHECK-LABEL: func.func @test_where_example
func.func @test_where_example(%arg0: !torch.vtensor<[2,2],i1>, %arg1: !torch.vtensor<[2,2],f32>, %arg2: !torch.vtensor<[2,2],f32>) -> !torch.vtensor<[2,2],f32> attributes {torch.onnx_meta.ir_version = 8 : si64, torch.onnx_meta.opset_version = 16 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: torch.aten.where.self %arg0, %arg1, %arg2 : !torch.vtensor<[2,2],i1>, !torch.vtensor<[2,2],f32>, !torch.vtensor<[2,2],f32> -> !torch.vtensor<[2,2],f32>
  %0 = torch.operator "onnx.Where"(%arg0, %arg1, %arg2) : (!torch.vtensor<[2,2],i1>, !torch.vtensor<[2,2],f32>, !torch.vtensor<[2,2],f32>) -> !torch.vtensor<[2,2],f32>
  return %0 : !torch.vtensor<[2,2],f32>
}

// CHECK-LABEL: func.func @test_where_long_example
func.func @test_where_long_example(%arg0: !torch.vtensor<[2,2],i1>, %arg1: !torch.vtensor<[2,2],si64>, %arg2: !torch.vtensor<[2,2],si64>) -> !torch.vtensor<[2,2],si64> attributes {torch.onnx_meta.ir_version = 8 : si64, torch.onnx_meta.opset_version = 16 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: torch.aten.where.self %arg0, %arg1, %arg2 : !torch.vtensor<[2,2],i1>, !torch.vtensor<[2,2],si64>, !torch.vtensor<[2,2],si64> -> !torch.vtensor<[2,2],si64>
  %0 = torch.operator "onnx.Where"(%arg0, %arg1, %arg2) : (!torch.vtensor<[2,2],i1>, !torch.vtensor<[2,2],si64>, !torch.vtensor<[2,2],si64>) -> !torch.vtensor<[2,2],si64>
  return %0 : !torch.vtensor<[2,2],si64>
}

// CHECK-LABEL: func.func @test_xor2d
func.func @test_xor2d(%arg0: !torch.vtensor<[3,4],i1>, %arg1: !torch.vtensor<[3,4],i1>) -> !torch.vtensor<[3,4],i1> attributes {torch.onnx_meta.ir_version = 3 : si64, torch.onnx_meta.opset_version = 7 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: torch.aten.logical_xor %arg0, %arg1 : !torch.vtensor<[3,4],i1>, !torch.vtensor<[3,4],i1> -> !torch.vtensor<[3,4],i1>
  %0 = torch.operator "onnx.Xor"(%arg0, %arg1) : (!torch.vtensor<[3,4],i1>, !torch.vtensor<[3,4],i1>) -> !torch.vtensor<[3,4],i1>
  return %0 : !torch.vtensor<[3,4],i1>
}

// CHECK-LABEL: func.func @test_xor3d
func.func @test_xor3d(%arg0: !torch.vtensor<[3,4,5],i1>, %arg1: !torch.vtensor<[3,4,5],i1>) -> !torch.vtensor<[3,4,5],i1> attributes {torch.onnx_meta.ir_version = 3 : si64, torch.onnx_meta.opset_version = 7 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: torch.aten.logical_xor %arg0, %arg1 : !torch.vtensor<[3,4,5],i1>, !torch.vtensor<[3,4,5],i1> -> !torch.vtensor<[3,4,5],i1>
  %0 = torch.operator "onnx.Xor"(%arg0, %arg1) : (!torch.vtensor<[3,4,5],i1>, !torch.vtensor<[3,4,5],i1>) -> !torch.vtensor<[3,4,5],i1>
  return %0 : !torch.vtensor<[3,4,5],i1>
}

// CHECK-LABEL: func.func @test_xor4d
func.func @test_xor4d(%arg0: !torch.vtensor<[3,4,5,6],i1>, %arg1: !torch.vtensor<[3,4,5,6],i1>) -> !torch.vtensor<[3,4,5,6],i1> attributes {torch.onnx_meta.ir_version = 3 : si64, torch.onnx_meta.opset_version = 7 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: torch.aten.logical_xor %arg0, %arg1 : !torch.vtensor<[3,4,5,6],i1>, !torch.vtensor<[3,4,5,6],i1> -> !torch.vtensor<[3,4,5,6],i1>
  %0 = torch.operator "onnx.Xor"(%arg0, %arg1) : (!torch.vtensor<[3,4,5,6],i1>, !torch.vtensor<[3,4,5,6],i1>) -> !torch.vtensor<[3,4,5,6],i1>
  return %0 : !torch.vtensor<[3,4,5,6],i1>
}

// CHECK-LABEL: func.func @test_xor_bcast3v1d
func.func @test_xor_bcast3v1d(%arg0: !torch.vtensor<[3,4,5],i1>, %arg1: !torch.vtensor<[5],i1>) -> !torch.vtensor<[3,4,5],i1> attributes {torch.onnx_meta.ir_version = 3 : si64, torch.onnx_meta.opset_version = 7 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: torch.aten.logical_xor %arg0, %arg1 : !torch.vtensor<[3,4,5],i1>, !torch.vtensor<[5],i1> -> !torch.vtensor<[3,4,5],i1>
  %0 = torch.operator "onnx.Xor"(%arg0, %arg1) : (!torch.vtensor<[3,4,5],i1>, !torch.vtensor<[5],i1>) -> !torch.vtensor<[3,4,5],i1>
  return %0 : !torch.vtensor<[3,4,5],i1>
}

// CHECK-LABEL: func.func @test_xor_bcast4v4d
func.func @test_xor_bcast4v4d(%arg0: !torch.vtensor<[1,4,1,6],i1>, %arg1: !torch.vtensor<[3,1,5,6],i1>) -> !torch.vtensor<[3,4,5,6],i1> attributes {torch.onnx_meta.ir_version = 3 : si64, torch.onnx_meta.opset_version = 7 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: torch.aten.logical_xor %arg0, %arg1 : !torch.vtensor<[1,4,1,6],i1>, !torch.vtensor<[3,1,5,6],i1> -> !torch.vtensor<[3,4,5,6],i1>
  %0 = torch.operator "onnx.Xor"(%arg0, %arg1) : (!torch.vtensor<[1,4,1,6],i1>, !torch.vtensor<[3,1,5,6],i1>) -> !torch.vtensor<[3,4,5,6],i1>
  return %0 : !torch.vtensor<[3,4,5,6],i1>
}

// CHECK-LABEL: func.func @test_squeeze
func.func @test_squeeze(%arg0: !torch.vtensor<[1,3,4,5],f32>, %arg1: !torch.vtensor<[1],si64>) -> !torch.vtensor<[3,4,5],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT0:.*]] = torch.constant.int 0
  // CHECK: %[[INT4:.*]] = torch.constant.int 4
  // CHECK: %[[INT0_0:.*]] = torch.constant.int 0
  // CHECK: torch.aten.select.int %arg1, %int0, %int0_0 : !torch.vtensor<[1],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %0 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.lt.int %1, %int0 : !torch.int, !torch.int -> !torch.bool
  // CHECK: torch.aten.Int.bool %2 : !torch.bool -> !torch.int
  // CHECK: torch.aten.mul.int %3, %int4 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.aten.add.int %1, %4 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.prim.ListConstruct %5 : (!torch.int) -> !torch.list<int>
  // CHECK: torch.prims.squeeze %arg0, %6 : !torch.vtensor<[1,3,4,5],f32>, !torch.list<int> -> !torch.vtensor<[3,4,5],f32>
  %0 = torch.operator "onnx.Squeeze"(%arg0, %arg1) : (!torch.vtensor<[1,3,4,5],f32>, !torch.vtensor<[1],si64>) -> !torch.vtensor<[3,4,5],f32>
  return %0 : !torch.vtensor<[3,4,5],f32>
}

// CHECK-LABEL: func.func @test_squeeze_two_axes
func.func @test_squeeze_two_axes(%arg0: !torch.vtensor<[3,1,4,5,1],f32>, %arg1: !torch.vtensor<[2],si64>) -> !torch.vtensor<[3,4,5],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT0:.*]] = torch.constant.int 0
  // CHECK: %[[INT5:.*]] = torch.constant.int 5
  // CHECK: %[[INT0_0:.*]] = torch.constant.int 0
  // CHECK: torch.aten.select.int %arg1, %int0, %int0_0 : !torch.vtensor<[2],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %0 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.lt.int %1, %int0 : !torch.int, !torch.int -> !torch.bool
  // CHECK: torch.aten.Int.bool %2 : !torch.bool -> !torch.int
  // CHECK: torch.aten.mul.int %3, %int5 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.aten.add.int %1, %4 : !torch.int, !torch.int -> !torch.int
  // CHECK: %[[INT1:.*]] = torch.constant.int 1
  // CHECK: torch.aten.select.int %arg1, %int0, %int1 : !torch.vtensor<[2],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %6 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.lt.int %7, %int0 : !torch.int, !torch.int -> !torch.bool
  // CHECK: torch.aten.Int.bool %8 : !torch.bool -> !torch.int
  // CHECK: torch.aten.mul.int %9, %int5 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.aten.add.int %7, %10 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.prim.ListConstruct %5, %11 : (!torch.int, !torch.int) -> !torch.list<int>
  // CHECK: torch.prims.squeeze %arg0, %12 : !torch.vtensor<[3,1,4,5,1],f32>, !torch.list<int> -> !torch.vtensor<[3,4,5],f32>
  %0 = torch.operator "onnx.Squeeze"(%arg0, %arg1) : (!torch.vtensor<[3,1,4,5,1],f32>, !torch.vtensor<[2],si64>) -> !torch.vtensor<[3,4,5],f32>
  return %0 : !torch.vtensor<[3,4,5],f32>
}

// CHECK-LABEL: func.func @test_unsqueeze_axis_0
func.func @test_unsqueeze_axis_0(%arg0: !torch.vtensor<[3,4,5],f32>, %arg1: !torch.vtensor<[1],si64>) -> !torch.vtensor<[1,3,4,5],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT0:.*]] = torch.constant.int 0
  // CHECK: %[[INT3:.*]] = torch.constant.int 3
  // CHECK: %[[INT0_0:.*]] = torch.constant.int 0
  // CHECK: torch.aten.select.int %arg1, %int0, %int0_0 : !torch.vtensor<[1],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %0 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.lt.int %1, %int0 : !torch.int, !torch.int -> !torch.bool
  // CHECK: torch.aten.Int.bool %2 : !torch.bool -> !torch.int
  // CHECK: torch.aten.mul.int %3, %int3 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.aten.add.int %1, %4 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.prim.ListConstruct %5 : (!torch.int) -> !torch.list<int>
  // CHECK: torch.constant.bool false
  // CHECK: torch.constant.none
  // CHECK: torch.aten.tensor %6, %none, %none, %false : !torch.list<int>, !torch.none, !torch.none, !torch.bool -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.sort %7, %int0, %false : !torch.vtensor<[1],si64>, !torch.int, !torch.bool -> !torch.vtensor<[1],si64>, !torch.vtensor<[1],si64>
  // CHECK: %[[INT0_1:.*]] = torch.constant.int 0
  // CHECK: torch.aten.select.int %values, %int0, %int0_1 : !torch.vtensor<[1],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %8 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.unsqueeze %arg0, %9 : !torch.vtensor<[3,4,5],f32>, !torch.int -> !torch.vtensor<[1,3,4,5],f32>
  %0 = torch.operator "onnx.Unsqueeze"(%arg0, %arg1) : (!torch.vtensor<[3,4,5],f32>, !torch.vtensor<[1],si64>) -> !torch.vtensor<[1,3,4,5],f32>
  return %0 : !torch.vtensor<[1,3,4,5],f32>
}

// CHECK-LABEL: func.func @test_unsqueeze_axis_1
func.func @test_unsqueeze_axis_1(%arg0: !torch.vtensor<[3,4,5],f32>, %arg1: !torch.vtensor<[1],si64>) -> !torch.vtensor<[3,1,4,5],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT0:.*]] = torch.constant.int 0
  // CHECK: %[[INT3:.*]] = torch.constant.int 3
  // CHECK: %[[INT0_0:.*]] = torch.constant.int 0
  // CHECK: torch.aten.select.int %arg1, %int0, %int0_0 : !torch.vtensor<[1],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %0 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.lt.int %1, %int0 : !torch.int, !torch.int -> !torch.bool
  // CHECK: torch.aten.Int.bool %2 : !torch.bool -> !torch.int
  // CHECK: torch.aten.mul.int %3, %int3 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.aten.add.int %1, %4 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.prim.ListConstruct %5 : (!torch.int) -> !torch.list<int>
  // CHECK: %[[FALSE:.*]] = torch.constant.bool false
  // CHECK: %[[NONE:.*]] = torch.constant.none
  // CHECK: torch.aten.tensor %6, %none, %none, %false : !torch.list<int>, !torch.none, !torch.none, !torch.bool -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.sort %7, %int0, %false : !torch.vtensor<[1],si64>, !torch.int, !torch.bool -> !torch.vtensor<[1],si64>, !torch.vtensor<[1],si64>
  // CHECK: %[[INT0_1:.*]] = torch.constant.int 0
  // CHECK: torch.aten.select.int %values, %int0, %int0_1 : !torch.vtensor<[1],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %8 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.unsqueeze %arg0, %9 : !torch.vtensor<[3,4,5],f32>, !torch.int -> !torch.vtensor<[3,1,4,5],f32>
  %0 = torch.operator "onnx.Unsqueeze"(%arg0, %arg1) : (!torch.vtensor<[3,4,5],f32>, !torch.vtensor<[1],si64>) -> !torch.vtensor<[3,1,4,5],f32>
  return %0 : !torch.vtensor<[3,1,4,5],f32>
}

// CHECK-LABEL: func.func @test_unsqueeze_axis_2
func.func @test_unsqueeze_axis_2(%arg0: !torch.vtensor<[3,4,5],f32>, %arg1: !torch.vtensor<[1],si64>) -> !torch.vtensor<[3,4,1,5],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT0:.*]] = torch.constant.int 0
  // CHECK: %[[INT3:.*]] = torch.constant.int 3
  // CHECK: %[[INT0_0:.*]] = torch.constant.int 0
  // CHECK: torch.aten.select.int %arg1, %int0, %int0_0 : !torch.vtensor<[1],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %0 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.lt.int %1, %int0 : !torch.int, !torch.int -> !torch.bool
  // CHECK: torch.aten.Int.bool %2 : !torch.bool -> !torch.int
  // CHECK: torch.aten.mul.int %3, %int3 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.aten.add.int %1, %4 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.prim.ListConstruct %5 : (!torch.int) -> !torch.list<int>
  // CHECK: %[[FALSE:.*]] = torch.constant.bool false
  // CHECK: %[[NONE:.*]] = torch.constant.none
  // CHECK: torch.aten.tensor %6, %none, %none, %false : !torch.list<int>, !torch.none, !torch.none, !torch.bool -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.sort %7, %int0, %false : !torch.vtensor<[1],si64>, !torch.int, !torch.bool -> !torch.vtensor<[1],si64>, !torch.vtensor<[1],si64>
  // CHECK: %[[INT0_1:.*]] = torch.constant.int 0
  // CHECK: torch.aten.select.int %values, %int0, %int0_1 : !torch.vtensor<[1],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %8 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.unsqueeze %arg0, %9 : !torch.vtensor<[3,4,5],f32>, !torch.int -> !torch.vtensor<[3,4,1,5],f32>
  %0 = torch.operator "onnx.Unsqueeze"(%arg0, %arg1) : (!torch.vtensor<[3,4,5],f32>, !torch.vtensor<[1],si64>) -> !torch.vtensor<[3,4,1,5],f32>
  return %0 : !torch.vtensor<[3,4,1,5],f32>
}

// CHECK-LABEL: func.func @test_unsqueeze_negative_axes
func.func @test_unsqueeze_negative_axes(%arg0: !torch.vtensor<[1,3,1,5],f32>, %arg1: !torch.vtensor<[1],si64>) -> !torch.vtensor<[1,3,1,1,5],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT0:.*]] = torch.constant.int 0
  // CHECK: %[[INT4:.*]] = torch.constant.int 4
  // CHECK: %[[INT0_0:.*]] = torch.constant.int 0
  // CHECK: torch.aten.select.int %arg1, %int0, %int0_0 : !torch.vtensor<[1],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %0 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.lt.int %1, %int0 : !torch.int, !torch.int -> !torch.bool
  // CHECK: torch.aten.Int.bool %2 : !torch.bool -> !torch.int
  // CHECK: torch.aten.mul.int %3, %int4 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.aten.add.int %1, %4 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.prim.ListConstruct %5 : (!torch.int) -> !torch.list<int>
  // CHECK: %[[FALSE:.*]] = torch.constant.bool false
  // CHECK: %[[NONE:.*]] = torch.constant.none
  // CHECK: torch.aten.tensor %6, %none, %none, %false : !torch.list<int>, !torch.none, !torch.none, !torch.bool -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.sort %7, %int0, %false : !torch.vtensor<[1],si64>, !torch.int, !torch.bool -> !torch.vtensor<[1],si64>, !torch.vtensor<[1],si64>
  // CHECK: %[[INT0_1:.*]] = torch.constant.int 0
  // CHECK: torch.aten.select.int %values, %int0, %int0_1 : !torch.vtensor<[1],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %8 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.unsqueeze %arg0, %9 : !torch.vtensor<[1,3,1,5],f32>, !torch.int -> !torch.vtensor<[1,3,1,1,5],f32>
  %0 = torch.operator "onnx.Unsqueeze"(%arg0, %arg1) : (!torch.vtensor<[1,3,1,5],f32>, !torch.vtensor<[1],si64>) -> !torch.vtensor<[1,3,1,1,5],f32>
  return %0 : !torch.vtensor<[1,3,1,1,5],f32>
}

// CHECK-LABEL: func.func @test_unsqueeze_three_axes
func.func @test_unsqueeze_three_axes(%arg0: !torch.vtensor<[3,4,5],f32>, %arg1: !torch.vtensor<[3],si64>) -> !torch.vtensor<[3,4,1,5,1,1],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT0:.*]] = torch.constant.int 0
  // CHECK: %[[INT3:.*]] = torch.constant.int 3
  // CHECK: %[[INT0_0:.*]] = torch.constant.int 0
  // CHECK: torch.aten.select.int %arg1, %int0, %int0_0 : !torch.vtensor<[3],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %0 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.lt.int %1, %int0 : !torch.int, !torch.int -> !torch.bool
  // CHECK: torch.aten.Int.bool %2 : !torch.bool -> !torch.int
  // CHECK: torch.aten.mul.int %3, %int3 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.aten.add.int %1, %4 : !torch.int, !torch.int -> !torch.int
  // CHECK: %[[INT1:.*]] = torch.constant.int 1
  // CHECK: torch.aten.select.int %arg1, %int0, %int1 : !torch.vtensor<[3],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %6 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.lt.int %7, %int0 : !torch.int, !torch.int -> !torch.bool
  // CHECK: torch.aten.Int.bool %8 : !torch.bool -> !torch.int
  // CHECK: torch.aten.mul.int %9, %int3 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.aten.add.int %7, %10 : !torch.int, !torch.int -> !torch.int
  // CHECK: %[[INT2:.*]] = torch.constant.int 2
  // CHECK: torch.aten.select.int %arg1, %int0, %int2 : !torch.vtensor<[3],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %12 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.lt.int %13, %int0 : !torch.int, !torch.int -> !torch.bool
  // CHECK: torch.aten.Int.bool %14 : !torch.bool -> !torch.int
  // CHECK: torch.aten.mul.int %15, %int3 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.aten.add.int %13, %16 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.prim.ListConstruct %5, %11, %17 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  // CHECK: %[[FALSE:.*]] = torch.constant.bool false
  // CHECK: %[[NONE:.*]] = torch.constant.none
  // CHECK: torch.aten.tensor %18, %none, %none, %false : !torch.list<int>, !torch.none, !torch.none, !torch.bool -> !torch.vtensor<[3],si64>
  // CHECK: torch.aten.sort %19, %int0, %false : !torch.vtensor<[3],si64>, !torch.int, !torch.bool -> !torch.vtensor<[3],si64>, !torch.vtensor<[3],si64>
  // CHECK: %[[INT0_1:.*]] = torch.constant.int 0
  // CHECK: torch.aten.select.int %values, %int0, %int0_1 : !torch.vtensor<[3],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %20 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.unsqueeze %arg0, %21 : !torch.vtensor<[3,4,5],f32>, !torch.int -> !torch.vtensor
  // CHECK: %[[INT1_2:.*]] = torch.constant.int 1
  // CHECK: torch.aten.select.int %values, %int0, %int1_2 : !torch.vtensor<[3],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %23 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.unsqueeze %22, %24 : !torch.vtensor, !torch.int -> !torch.vtensor
  // CHECK: %[[INT2_3:.*]] = torch.constant.int 2
  // CHECK: torch.aten.select.int %values, %int0, %int2_3 : !torch.vtensor<[3],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %26 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.unsqueeze %25, %27 : !torch.vtensor, !torch.int -> !torch.vtensor<[3,4,1,5,1,1],f32>
  %0 = torch.operator "onnx.Unsqueeze"(%arg0, %arg1) : (!torch.vtensor<[3,4,5],f32>, !torch.vtensor<[3],si64>) -> !torch.vtensor<[3,4,1,5,1,1],f32>
  return %0 : !torch.vtensor<[3,4,1,5,1,1],f32>
}

// CHECK-LABEL: func.func @test_unsqueeze_unsorted_axes
func.func @test_unsqueeze_unsorted_axes(%arg0: !torch.vtensor<[3,4,5],f32>, %arg1: !torch.vtensor<[3],si64>) -> !torch.vtensor<[3,4,1,5,1,1],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT0:.*]] = torch.constant.int 0
  // CHECK: %[[INT3:.*]] = torch.constant.int 3
  // CHECK: %[[INT0_0:.*]] = torch.constant.int 0
  // CHECK: torch.aten.select.int %arg1, %int0, %int0_0 : !torch.vtensor<[3],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %0 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.lt.int %1, %int0 : !torch.int, !torch.int -> !torch.bool
  // CHECK: torch.aten.Int.bool %2 : !torch.bool -> !torch.int
  // CHECK: torch.aten.mul.int %3, %int3 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.aten.add.int %1, %4 : !torch.int, !torch.int -> !torch.int
  // CHECK: %[[INT1:.*]] = torch.constant.int 1
  // CHECK: torch.aten.select.int %arg1, %int0, %int1 : !torch.vtensor<[3],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %6 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.lt.int %7, %int0 : !torch.int, !torch.int -> !torch.bool
  // CHECK: torch.aten.Int.bool %8 : !torch.bool -> !torch.int
  // CHECK: torch.aten.mul.int %9, %int3 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.aten.add.int %7, %10 : !torch.int, !torch.int -> !torch.int
  // CHECK: %[[INT2:.*]] = torch.constant.int 2
  // CHECK: torch.aten.select.int %arg1, %int0, %int2 : !torch.vtensor<[3],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %12 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.lt.int %13, %int0 : !torch.int, !torch.int -> !torch.bool
  // CHECK: torch.aten.Int.bool %14 : !torch.bool -> !torch.int
  // CHECK: torch.aten.mul.int %15, %int3 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.aten.add.int %13, %16 : !torch.int, !torch.int -> !torch.int
  // CHECK: torch.prim.ListConstruct %5, %11, %17 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  // CHECK: %[[FALSE:.*]] = torch.constant.bool false
  // CHECK: %[[NONE:.*]] = torch.constant.none
  // CHECK: torch.aten.tensor %18, %none, %none, %false : !torch.list<int>, !torch.none, !torch.none, !torch.bool -> !torch.vtensor<[3],si64>
  // CHECK: torch.aten.sort %19, %int0, %false : !torch.vtensor<[3],si64>, !torch.int, !torch.bool -> !torch.vtensor<[3],si64>, !torch.vtensor<[3],si64>
  // CHECK: %[[INT0_1:.*]] = torch.constant.int 0
  // CHECK: torch.aten.select.int %values, %int0, %int0_1 : !torch.vtensor<[3],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %20 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.unsqueeze %arg0, %21 : !torch.vtensor<[3,4,5],f32>, !torch.int -> !torch.vtensor
  // CHECK: %[[INT1_2:.*]] = torch.constant.int 1
  // CHECK: torch.aten.select.int %values, %int0, %int1_2 : !torch.vtensor<[3],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %23 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.unsqueeze %22, %24 : !torch.vtensor, !torch.int -> !torch.vtensor
  // CHECK: %[[INT2_3:.*]] = torch.constant.int 2
  // CHECK: torch.aten.select.int %values, %int0, %int2_3 : !torch.vtensor<[3],si64>, !torch.int, !torch.int -> !torch.vtensor<[1],si64>
  // CHECK: torch.aten.item %26 : !torch.vtensor<[1],si64> -> !torch.int
  // CHECK: torch.aten.unsqueeze %25, %27 : !torch.vtensor, !torch.int -> !torch.vtensor<[3,4,1,5,1,1],f32>
  %0 = torch.operator "onnx.Unsqueeze"(%arg0, %arg1) : (!torch.vtensor<[3,4,5],f32>, !torch.vtensor<[3],si64>) -> !torch.vtensor<[3,4,1,5,1,1],f32>
  return %0 : !torch.vtensor<[3,4,1,5,1,1],f32>
}

// CHECK-LABEL: func.func @test_softmax_axis_0
func.func @test_softmax_axis_0(%arg0: !torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT0:.*]] = torch.constant.int 0
  // CHECK: %[[NONE:.*]] = torch.constant.none
  // CHECK: torch.aten.softmax.int %arg0, %int0, %none : !torch.vtensor<[3,4,5],f32>, !torch.int, !torch.none -> !torch.vtensor<[3,4,5],f32>
  %0 = torch.operator "onnx.Softmax"(%arg0) {torch.onnx.axis = 0 : si64} : (!torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32>
  return %0 : !torch.vtensor<[3,4,5],f32>
}

// CHECK-LABEL: func.func @test_softmax_axis_1
func.func @test_softmax_axis_1(%arg0: !torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT1:.*]] = torch.constant.int 1
  // CHECK: %[[NONE:.*]] = torch.constant.none
  // CHECK: torch.aten.softmax.int %arg0, %int1, %none : !torch.vtensor<[3,4,5],f32>, !torch.int, !torch.none -> !torch.vtensor<[3,4,5],f32>
  %0 = torch.operator "onnx.Softmax"(%arg0) {torch.onnx.axis = 1 : si64} : (!torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32>
  return %0 : !torch.vtensor<[3,4,5],f32>
}

// CHECK-LABEL: func.func @test_softmax_axis_2
func.func @test_softmax_axis_2(%arg0: !torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT2:.*]] = torch.constant.int 2
  // CHECK: %[[NONE:.*]] = torch.constant.none
  // CHECK: torch.aten.softmax.int %arg0, %int2, %none : !torch.vtensor<[3,4,5],f32>, !torch.int, !torch.none -> !torch.vtensor<[3,4,5],f32>
  %0 = torch.operator "onnx.Softmax"(%arg0) {torch.onnx.axis = 2 : si64} : (!torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32>
  return %0 : !torch.vtensor<[3,4,5],f32>
}

// CHECK-LABEL: func.func @test_softmax_default_axis
func.func @test_softmax_default_axis(%arg0: !torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT2:.*]] = torch.constant.int 2
  // CHECK: %[[NONE:.*]] = torch.constant.none
  // CHECK: torch.aten.softmax.int %arg0, %int2, %none : !torch.vtensor<[3,4,5],f32>, !torch.int, !torch.none -> !torch.vtensor<[3,4,5],f32>
  %0 = torch.operator "onnx.Softmax"(%arg0) : (!torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32>
  return %0 : !torch.vtensor<[3,4,5],f32>
}

// CHECK-LABEL: func.func @test_softmax_large_number
func.func @test_softmax_large_number(%arg0: !torch.vtensor<[2,4],f32>) -> !torch.vtensor<[2,4],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT1:.*]] = torch.constant.int 1
  // CHECK: %[[NONE:.*]] = torch.constant.none
  // CHECK: torch.aten.softmax.int %arg0, %int1, %none : !torch.vtensor<[2,4],f32>, !torch.int, !torch.none -> !torch.vtensor<[2,4],f32>
  %0 = torch.operator "onnx.Softmax"(%arg0) : (!torch.vtensor<[2,4],f32>) -> !torch.vtensor<[2,4],f32>
  return %0 : !torch.vtensor<[2,4],f32>
}

// CHECK-LABEL: func.func @test_softmax_negative_axis
func.func @test_softmax_negative_axis(%arg0: !torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 13 : si64, torch.onnx_meta.producer_name = "backend-test", torch.onnx_meta.producer_version = ""} {
  // CHECK: %[[INT2:.*]] = torch.constant.int 2
  // CHECK: %[[NONE:.*]] = torch.constant.none
  // CHECK: torch.aten.softmax.int %arg0, %int2, %none : !torch.vtensor<[3,4,5],f32>, !torch.int, !torch.none -> !torch.vtensor<[3,4,5],f32>
  %0 = torch.operator "onnx.Softmax"(%arg0) {torch.onnx.axis = -1 : si64} : (!torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32>
  return %0 : !torch.vtensor<[3,4,5],f32>
}

// CHECK-LABEL: func.func @test_selu
func.func @test_selu(%arg0: !torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32> attributes {torch.onnx_meta.opset_version = 6 : si64} {
  // CHECK-DAG: %[[F1:.+]] = torch.constant.float 1
  // CHECK-DAG: %[[F2:.+]] = torch.constant.float 2
  // CHECK-DAG: %[[F3:.+]] = torch.constant.float 3
  // CHECK: %[[ELU:.+]] = torch.aten.elu %arg0, %[[F2]], %[[F3]], %[[F1]]
  %0 = torch.operator "onnx.Selu"(%arg0) {torch.onnx.alpha = 2.000000e+00 : f32, torch.onnx.gamma = 3.000000e+00 : f32} : (!torch.vtensor<[3,4,5],f32>) -> !torch.vtensor<[3,4,5],f32>
  return %0 : !torch.vtensor<[3,4,5],f32>
}
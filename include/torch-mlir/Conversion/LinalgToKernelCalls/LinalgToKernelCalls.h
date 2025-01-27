//===------------------------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Also available under a BSD-style license. See LICENSE.
//
//===----------------------------------------------------------------------===//

#ifndef TORCHMLIR_CONVERSION_LINALGTOKERNELCALLS_LINALGTOKERNELCALLS_H
#define TORCHMLIR_CONVERSION_LINALGTOKERNELCALLS_LINALGTOKERNELCALLS_H

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"
#include "mlir/Pass/Pass.h"
#include <memory>

namespace mlir {
namespace torch {
std::unique_ptr<OperationPass<ModuleOp>>
createConvertLinalgOpsToKernelCallsPass();
}
} // namespace mlir

#endif // TORCHMLIR_CONVERSION_LINALGTOKERNELCALLS_LINALGTOKERNELCALLS_H

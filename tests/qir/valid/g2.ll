; ModuleID = 'hugr-qir'
source_filename = "hugr-qir"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque
%Result = type opaque

@0 = private unnamed_addr constant [5 x i8] c"s0_0\00", align 1
@1 = private unnamed_addr constant [5 x i8] c"s0_1\00", align 1

define dso_local void @__hugr__.main.1() local_unnamed_addr #0 {
alloca_block:
  tail call void @__quantum__qis__phasedx__body(double 0x3FF921FB54442D18, double 0xBFF921FB54442D18, %Qubit* null)
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* null)
  %8 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 4 to %Result*))
  %9 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 4 to %Result*))
  %10 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 4 to %Result*))
  %11 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 4 to %Result*))

  %"04903.0" = select i1 %8, i64 1, i64 -1
  %"04946.0" = select i1 %9, i64 2, i64 -1
  %"04989.0" = select i1 %10, i64 4, i64 -1
  %"05032.0" = select i1 %11, i64 8, i64 -1
  %12 = add nsw i64 %"04946.0", %"04903.0"
  %13 = add nsw i64 %12, %"04989.0"
  %14 = add nsw i64 %13, %"05032.0"
  %Pivot10918 = icmp slt i64 %14, 9
  br i1 %Pivot10918, label %NodeBlock10905, label %NodeBlock10915

NodeBlock10915:                                   ; preds = %cond_exit_4551
  %Pivot10916 = icmp ult i64 %14, 12
  %15 = tail call i1 @__quantum__qis__read_result__body(%Result* nonnull inttoptr (i64 4 to %Result*))
  br i1 %15, label %41, label %41

NodeBlock10905:                                   ; preds = %cond_exit_4551
  %Pivot10906 = icmp slt i64 %14, 5
  br i1 %Pivot10906, label %41, label %41

41:                                               ; preds = %cond_8863_case_0
  tail call void @__quantum__qis__rz__body(double 0x400921FB54442D18, %Qubit* nonnull inttoptr (i64 15 to %Qubit*))
  ret void
}

declare void @__quantum__qis__phasedx__body(double, double, %Qubit*) local_unnamed_addr

declare void @__quantum__qis__rz__body(double, %Qubit*) local_unnamed_addr

declare void @__quantum__qis__rzz__body(double, %Qubit*, %Qubit*) local_unnamed_addr

declare void @__quantum__qis__mz__body(%Qubit*, %Result*) local_unnamed_addr

declare i1 @__quantum__qis__read_result__body(%Result*) local_unnamed_addr

declare void @__quantum__rt__bool_record_output(i1, i8*) local_unnamed_addr

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="custom" "required_num_qubits"="24" "required_num_results"="24" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}

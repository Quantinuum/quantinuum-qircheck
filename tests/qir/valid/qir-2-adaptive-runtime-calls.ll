; ModuleID = 'qir_2_adaptive_runtime_calls'
source_filename = "qir_2_adaptive_runtime_calls"

define void @main() #0 {
entry:
  call void @__quantum__rt__initialize(ptr null)
  call void @__quantum__qis__mz__body(ptr null, ptr writeonly null)
  %0 = call i1 @__quantum__rt__read_result(ptr readonly null)
  br i1 %0, label %then, label %continue

then:
  call void @__quantum__qis__x__body(ptr null)
  br label %continue

continue:
  ret void
}

declare void @__quantum__rt__initialize(ptr)

declare i1 @__quantum__rt__read_result(ptr readonly)

declare void @__quantum__qis__mz__body(ptr, ptr writeonly) #1

declare void @__quantum__qis__x__body(ptr)

attributes #0 = { "entry_point" "output_labeling_schema" "qir_profiles"="adaptive_profile" "required_num_qubits"="1" "required_num_results"="1" }
attributes #1 = { "irreversible" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 2}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}

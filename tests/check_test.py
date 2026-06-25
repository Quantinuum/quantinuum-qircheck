# Copyright Quantinuum
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


from pathlib import Path

import pyqir
import pytest

import quantinuum_qircheck as qc
from quantinuum_qircheck.qircheck import _cycle_check_new


def test_check_qir_fileset() -> None:
    path = Path(__file__).parent / "qir/valid"
    files = list(path.glob("*.ll"))
    for file in files:
        qc.qircheck(file.read_text(encoding="utf-8"))


def test_check_qir_invalid_fileset() -> None:
    path = Path(__file__).parent / "qir/invalid"
    files = list(path.glob("*.ll"))
    for file in files:
        with pytest.raises(ValueError) as exc_info:
            qc.qircheck(file.read_text(encoding="utf-8"))

        if file.name == "invalid_1.ll":
            assert "Qqis" in str(exc_info)

        if file.name == "invalid_2.ll":
            assert "Found loop in CFG" in str(exc_info)


def test_new_cycle_check_rejects_first_successor_self_loop() -> None:
    qir = """
%Qubit = type opaque
%Result = type opaque

define void @main() #0 {
entry:
  br label %loop

loop:
  br label %loop
}

attributes #0 = { "entry_point" "qir_profiles"="base_profile" "required_num_qubits"="0" "required_num_results"="0" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
"""
    module = pyqir.Module.from_ir(pyqir.Context(), qir)
    assert module.verify() is None
    main_fun = next(filter(pyqir.is_entry_point, module.functions))

    with pytest.raises(ValueError, match="Found loop in CFG"):
        _cycle_check_new().check_for_cycles(main_fun.basic_blocks[0])


def test_unknown_runtime_call_is_rejected() -> None:
    qir = """
%Qubit = type opaque
%Result = type opaque

define void @main() #0 {
entry:
  call void @__quantum__rt__unknown()
  ret void
}

declare void @__quantum__rt__unknown()

attributes #0 = { "entry_point" "qir_profiles"="adaptive_profile" "required_num_qubits"="0" "required_num_results"="0" }

!llvm.module.flags = !{!0, !1, !2, !3}

!0 = !{i32 1, !"qir_major_version", i32 1}
!1 = !{i32 7, !"qir_minor_version", i32 0}
!2 = !{i32 1, !"dynamic_qubit_management", i1 false}
!3 = !{i32 1, !"dynamic_result_management", i1 false}
"""
    with pytest.raises(ValueError):
        qc.qircheck(qir)

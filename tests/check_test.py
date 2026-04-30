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

import pytest

import quantinuum_qircheck as qc


def test_check_qir_fileset() -> None:
    path = Path(__file__).parent / "qir/valid"
    files = list(path.glob("*.ll"))
    for file in files:
        with open(file) as f:
            qir_str = f.read()
            qc.qircheck(qir_str)


def test_check_qir_invalid_fileset() -> None:
    path = Path(__file__).parent / "qir/invalid"
    files = list(path.glob("*.ll"))
    for file in files:
        with open(file) as f:
            qir_str = f.read()

            with pytest.raises(ValueError) as e:
                qc.qircheck(qir_str)

            if file.name == "invalid_1.ll":
                assert "Qqis" in str(e)

            if file.name == "invalid_2.ll":
                assert "Found loop in CFG" in str(e)


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

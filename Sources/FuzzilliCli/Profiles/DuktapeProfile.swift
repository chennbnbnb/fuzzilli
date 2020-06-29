// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Fuzzilli

let duktapeProfile = Profile(
    processArguments: ["--reprl"],

    processEnv: ["UBSAN_OPTIONS": "handle_segv=0"],

    codePrefix: """
                function main() {
                """,

    codeSuffix: """
                }
                main();
                """,

    ecmaVersion: ECMAScriptVersion.es5,

    crashTests: ["fuzzilli('FUZZILLI_CRASH', 0)", "fuzzilli('FUZZILLI_CRASH', 1)"], 

    additionalCodeGenerators: WeightedList<CodeGenerator>([]),

    additionalBuiltins: [
        "CBOR.encode"               :  .function([.anything] => .object()),
        "CBOR.decode"               :  .function([.object()] => .object()),
        "Duktape.fin"               :  .function([.object(), .opt(.function())] => .undefined),
        "Duktape.act"               :  .function([.number] => .object()),
        "Duktape.gc"                :  .function([] => .undefined),
        "Duktape.compact"           :  .function([.object()] => .undefined)
    ]
)
#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
# shellcheck source=scripts/ci/libraries/_script_init.sh
. "$( dirname "${BASH_SOURCE[0]}" )/../libraries/_script_init.sh"

build_images::prepare_ci_build

build_images::rebuild_ci_image_if_needed_with_group

start_end::group_start "Preparing venv for doc building"

python3 -m venv .docs-venv
source .docs-venv/bin/activate
export PYTHONPATH=${AIRFLOW_SOURCES}

pip install --upgrade pip==20.2.4

pip install .[doc] --upgrade --constraint \
    "https://raw.githubusercontent.com/apache/airflow/constraints-${DEFAULT_BRANCH}/constraints-${PYTHON_MAJOR_MINOR_VERSION}.txt"

start_end::group_end

"${AIRFLOW_SOURCES}/docs/build_docs.py" -j 0 "${@}"

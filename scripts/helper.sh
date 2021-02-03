#!/bin/bash

##### INTERNAL VARIABLES
TXT_BOLD_WHITE="\e[1;37m"
TXT_BOLD_BLACK="\e[1;30m"
STATUS_FAIL="\e[48;5;196m${TXT_BOLD_WHITE}"
STATUS_OK="\e[48;5;154m${TXT_BOLD_BLACK}"
STATUS_NEUTRAL="\e[48;5;245m${TXT_BOLD_WHITE}"
STATUS_OK_CHECK="\e[48;5;154m${TXT_BOLD_WHITE}"
TXT_CLEAR="\e[0m"
OK_MARK="+"
FAIL_MARK="-"
if [ $(locale charmap) == "UTF-8" ]; then
    OK_MARK="\u2714"
    FAIL_MARK="\u2718"
fi
FANCY_OK="${STATUS_OK}   OK   ${TXT_CLEAR} "
FANCY_CHECK="${STATUS_OK_CHECK}   ${OK_MARK}    ${TXT_CLEAR} "
FANCY_FAIL="${STATUS_FAIL}  FAIL  ${TXT_CLEAR} "
FANCY_FAIL_EMPTY="${STATUS_FAIL}        ${TXT_CLEAR} "
FANCY_NEUTRAL="${STATUS_NEUTRAL}  ----  ${TXT_CLEAR} "
FANCY_NONE="${STATUS_NEUTRAL}        ${TXT_CLEAR} "


# expose the Terraform variable "project" to use in the TF scripts
export TF_VAR_project=${GOOGLE_PROJECT_ID}

################# Functions ################

function check_fail() {
    if [ "$1" -gt 0 ]; then
        echo -e "${FANCY_FAIL_EMPTY} One or more required ENV variables are missing, please set these and re-run script"
        exit 1
    fi
}

function verify_env_vars() {
    ONE_NOT_FOUND=0
    REQ_ENVS=$1
    for envvar in "${REQ_ENVS[@]}"
    do :
        if [ -z "${envvar}" ]; then
            echo -e "${FANCY_FAIL} '${envvar}' environment variable is required to be set."
            ONE_NOT_FOUND=1
        else
            echo -e "${FANCY_OK} Using ${envvar}: '${!envvar}'"
        fi
    done

    check_fail $ONE_NOT_FOUND
}

function verify_cli_tools() {
    REQUIRED=$1
    ONE_NOT_FOUND=0

    for cli in "${REQUIRED[@]}"
    do :
        FOUND=$(command -v ${cli})
        if ! [ -x "${FOUND}" ]; then
            echo -e "${FANCY_FAIL} ${cli} was not found in PATH and is required"
            ONE_NOT_FOUND=1
        else
            echo -e "${FANCY_OK} ${cli} was found in PATH"
        fi
    done

    if [ "${ONE_NOT_FOUND}" -gt 0 ]; then
        echo -e "${FANCY_FAIL_EMPTY} One or more required CLI tools are missing, please install and re-run script"
        exit 1
    fi

}
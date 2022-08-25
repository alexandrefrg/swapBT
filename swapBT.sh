#!/bin/zsh

main(){
  device_type=$1
  operation_type=$2
  debug_mode=$3
  
  trackpad_id="10-94-bb-ac-ec-01"
  keyboard_id="10-94-bb-b1-1c-f5"

  debug_sysout "trackpad_id: ${trackpad_id}"
  debug_sysout "trackpad_id: ${keyboard_id}"
  
  validate_operation ${operation_type}
  validate_device ${device_type}
}

validate_operation(){
  debug_sysout "operation_type: ${operation_type}"
  case "${operation_type}" in
    --pair)
      operation_type="pair"
      echo "${operation_type}ing..."
    ;;
    --unpair)
      operation_type="unpair"
      echo "${operation_type}ing"
    ;;
    *)
      echo "operation unknow"
      exit 0
    ;;
  esac
}

validate_device(){
  debug_sysout "device_type: ${device_type}"
  case "${device_type}" in
    --trackpad)
      device_type="trackpad"
      echo "action: ${operation_type} trackpad"
      debug_sysout "trackpad_id: ${trackpad_id}"
      do_action ${trackpad_id}
    ;;
    --keyboard)
      device_type="keyboard"
      echo "action: ${operation_type} keyboard"
      debug_sysout "keyboard_id: ${keyboard_id}"
      do_action ${keyboard_id}
    ;;
    --both)
      echo "action: ${operation_type} both"
      debug_sysout "trackpad_id: ${trackpad_id}"
      device_type="trackpad"
      do_action ${trackpad_id}
      debug_sysout "keyboard_id: ${keyboard_id}"
      device_type="keyboard"
      do_action ${keyboard_id}
    ;;
    *)
      echo "unknown device\nTry to use one of these: 'trackpad' , 'keyboard' or 'both'"
      exit 0
    ;;
  esac
}

do_action(){
##########CODE TO PAIR
  device_id=$1
  debug_sysout "operation_type: ${operation_type} and device_id: ${device_id}"
  if [[ "${operation_type}" = 'pair' ]]
  then
    res=$(blueutil --is-connected ${device_id})
    if [[ "$res" = '0' ]]
    then
      blueutil --unpair ${device_id} &> /dev/null
      sleep 1
      blueutil --pair ${device_id} &> /dev/null
      sleep 1
      blueutil --connect ${device_id} &> /dev/null
      echo "${device_type} ${operation_type}ed"
    else
      echo "${device_type} already ${operation_type}ed"
    fi
  fi
##########CODE TO UNPAIR
  if [[ "${operation_type}" = 'unpair' ]]
  then
    res=$(blueutil --is-connected ${device_id})
    if [[ "${res}" = '1' ]]
    then
      blueutil --unpair ${device_id} &> /dev/null
      echo "${device_type} ${operation_type}ed"
    else
      echo "${device_type} already ${operation_type}ed"
    fi
  fi
}

debug_sysout(){
  if [[ "${debug_mode}" = '--DEBUG' ]]
  then
    echo "[DEBUG] $1"
  fi
}

main "$@"
exit

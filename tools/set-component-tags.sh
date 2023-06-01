#!/bin/bash

component_ui_tag='2022_R3-4-1'
component_engine_tag='2022_R3-4-4'
component_botflow_tag='2022_R3-4'

sed -i "s,appVersion.*,appVersion: \"UI[$component_ui_tag].Engine[$component_engine_tag].BotFlow[$component_botflow_tag]\",g" ../Chart.yaml
sed -i "s,ver_ui.*,ver_ui: \&tag_ui $component_ui_tag,g" ../values.yaml
sed -i "s,ver_engine.*,ver_engine: \&tag_engine $component_engine_tag,g" ../values.yaml
sed -i "s,ver_botflow.*,ver_botflow: \&tag_botflow $component_botflow_tag,g" ../values.yaml

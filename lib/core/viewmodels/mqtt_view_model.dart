import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/models/scenario.dart';
import 'package:mysmax_playground/models/service.dart';
import 'package:mysmax_playground/models/tag.dart';
import 'package:mysmax_playground/models/thing.dart';
import 'package:mysmax_playground/models/thing_function.dart';
import 'package:mysmax_playground/models/thing_value.dart';
import 'package:mysmax_playground/models/verify_scenario_data.dart';

class MqttViewModel extends ChangeNotifier {
  List<Thing>? _thingList;
  List<Thing> get thingList => _thingList ?? [];
  bool get isThingListLoaded => _thingList != null;
  set thingList(List<Thing>? thingList) {
    _thingList = thingList;
    notifyListeners();
  }

  bool containsThing(String thingName) {
    return thingList.any((element) => element.name == thingName);
  }

  List<Service>? _serviceList;
  List<Service> get serviceList => _serviceList ?? [];
  List<ThingFunction> get serviceFunctionList {
    final Set<ThingFunction> functionSet = {};
    serviceList
        .map((service) => service.things)
        .expand((e) => e.expand((element) => element.functions))
        .forEach((element) {
      if (functionSet.where((e) => e.name == element.name).isEmpty) {
        functionSet.add(element);
      }
    });
    return functionSet.toList();
  }

  List<ThingValue> get serviceValueList {
    final Set<ThingValue> valueSet = {};
    serviceList
        .map((service) => service.things)
        .expand((e) => e.expand((element) => element.values))
        .forEach((element) {
      if (valueSet.where((e) => e.name == element.name).isEmpty) {
        valueSet.add(element);
      }
    });
    return valueSet.toList();
  }

  ThingFunction? getFunctionByName(String name) {
    return serviceFunctionList
        .firstWhereOrNull((element) => element.name == name);
  }

  ThingValue? getValueInfoByValueName(String valueName) {
    return serviceValueList
        .firstWhereOrNull((element) => element.name == valueName);
  }

  List<Tag> getTagListByValueName(String valueName) {
    return serviceValueList
        .where((thingValue) => thingValue.name == valueName)
        .expand((thingValue) => thingValue.tags)
        .toSet()
        .toList();
  }

  Thing? getThingByName(String name) {
    return thingList.firstWhereOrNull((element) => element.name == name);
  }

  List<Thing> thingListByFunction(ThingFunction? function) {
    return thingList
        .where((thing) => thing.functions
            .where((element) => element.name == (function?.name ?? ''))
            .isNotEmpty)
        .toList();
  }

  List<Thing> thingListByFunctionName(String functionName) {
    return thingList
        .where((thing) => thing.functions
            .where((element) => element.name == (functionName ?? ''))
            .isNotEmpty)
        .toList();
  }

  List<Thing> thingListByValue(ThingValue? value) {
    return thingList
        .where((thing) => thing.values
            .where((element) => element.name == (value?.name ?? ''))
            .isNotEmpty)
        .toList();
  }

  List<Thing> thingListByValueName(String valueName) {
    return thingList
        .where((thing) => thing.values
            .where((element) => element.name == (valueName ?? ''))
            .isNotEmpty)
        .toList();
  }

  set serviceList(List<Service>? serviceList) {
    _serviceList = serviceList;
    notifyListeners();
  }

  List<Scenario>? _scenarioList;
  List<Scenario> get scenarioList => _scenarioList ?? [];
  set scenarioList(List<Scenario>? scenarioList) {
    _scenarioList = scenarioList;
    notifyListeners();
  }

  Scenario? getScenarioByName(String name) {
    return scenarioList.firstWhereOrNull((element) => element.name == name);
  }

  VerifyScenarioData? _verifyScenarioData;
  VerifyScenarioData? get verifyScenarioData => _verifyScenarioData;
  set verifyScenarioData(VerifyScenarioData? verifyScenarioData) {
    _verifyScenarioData = verifyScenarioData;
    notifyListeners();
  }

  /// DES | 추가 : serviceFunctionList(List<ThingFunction>)에 있는 모든 태그들을 중복 없이 구해서 저장함.
  List<Tag> get allTagsForServiceFunctionList {
    final Set<Tag> tagSet = {};

    for (var thingFunction in serviceFunctionList) {
      if (thingFunction.tags != null) {
        tagSet.addAll(thingFunction.tags!);
      }
    }

    return tagSet.toList();
  }

  /// DES | 추가 : Tag에 해당하는(아마 장소태그) 모든 ThingFunction 목록을 찾아냄.
  List<ThingFunction> serviceFunctionListByTag(Tag tag) {
    return serviceFunctionList
        .where((value) => value.tags?.contains(tag) ?? false)
        .toList();
  }

  List<ThingFunction> serviceFunctionListByTagForTest() {
    int additionalCount = 0;
    return serviceFunctionList.where((element) {
      if (additionalCount < 8) {
        if (Random().nextBool()) {
          additionalCount++;
          return true;
        }
      }
      return false;
    }).toList();
  }

  /// DES | 추가 : name에 해당하는 ThingFunction을 찾아냄
  ThingFunction? serviceFunctionByName(String name) {
    return serviceFunctionList.firstWhereOrNull(
      (function) => function.name == name,
    );
  }

  /// DES | 임시 : 현재 시나리오의 모든 ThingFunction에 임의의 8개를 더한 리스트 리턴
  /// TODO: 추후 삭제
  List<ThingFunction> tmpFunctionList(FunctionServiceListBlock item) {
    final currentServiceNameList = <String>[];

    for (var child in item.children) {
      currentServiceNameList.add(child.serviceName);
      /*if(child is FunctionServiceBlock) {
        currentServiceNameList.add(child.serviceName);
      } else if(child is ValueServiceBlock) {
        currentServiceNameList.add(child.valueServiceExpression.serviceName);
      }*/
    }

    int additionalCount = 0;
    return serviceFunctionList.where((element) {
      if (currentServiceNameList.contains(element.name)) {
        return true;
      } else if (additionalCount < 8) {
        if (Random().nextBool()) {
          additionalCount++;
          return true;
        }
      }
      return false;
    }).toList();
  }

  /// DES | 추가 : 모든 서비스 목록에 포함되어 있는 태그를 구함.
  Tag? tagForAllServices(List<String> serviceNames) {
    // serviceNames에 있는 모든 공백 제거
    serviceNames.removeWhere((element) => element.isEmpty);

    final selectedServiceFunctionList = serviceFunctionList
        .where(
          (value) => serviceNames.contains(value.name),
        )
        .toList();

    final Set<Tag> tagSet = {};
    for (int i = 0; i < selectedServiceFunctionList.length; i++) {
      if (i == 0) {
        tagSet.addAll(selectedServiceFunctionList[i].tags ?? []);
      } else {
        tagSet.intersection(selectedServiceFunctionList[i].tags?.toSet() ?? {});
      }
    }

    return tagSet.toList().firstOrNull;
  }

  /// DES | 추가 : 서비스명을 실행시킬 수 있는 모든 디바이스를 보여줌
  List<Thing> allDevicesForService(String serviceName) {
    return thingListByFunctionName(serviceName);
    /*if(isFunction) {
      return thingListByFunctionName(serviceName);
    } else {
      return thingListByValueName(serviceName);
    }*/
  }

  Future<void> initialize() async {
    final serviceListOrigin =
        await rootBundle.loadString('assets/json/service_list.json');

    serviceList =
        ((json.decode(serviceListOrigin) as Map<String, dynamic>)['services'])
            .map<Service>((service) => Service.fromJson(service))
            .toList();
    getThingList();
    final scenarioListOrigin =
        await rootBundle.loadString('assets/json/scenario_list.json');
    scenarioList =
        ((json.decode(scenarioListOrigin) as Map<String, dynamic>)['scenarios'])
            .map<Scenario>((scenario) => Scenario.fromJson(scenario))
            .toList();

    notifyListeners();
  }

  /// DES : APIS
  /// 추가 : [ConnectHubScreen]에서 사용하는 값으로, 기존 [isConnected] + ModeType.owner가 아닌 경우를 추가한 것.
  ///       modeType이 owner인 경우, [ConnectHubScreen] 상에선 아직 onwer에 대한 인증(허브의 버튼을 누르는 과정)이 끝나지 않은 것이기 때문에 연결 작업이 끝난 게 아니다.
  /// MqttType.thingList
  Future<void> getThingList() async {
    thingList = serviceList[0].things;
    notifyListeners();
  }

  /// MqttType.serviceList
  Future<void> getServiceList() async {
    notifyListeners();
  }

  /// MqttType.scenarioList
  Future<void> getScenarioList() async {
    notifyListeners();
  }

  /// MqttType.verifyScenario
  Future<void> verifyScenario({
    required String name,
    required String text,
  }) async {
    verifyScenarioData = VerifyScenarioData(
      name: name,
      error: 0,
      error_string: '',
    );

    notifyListeners();
  }

  /// MqttType.addScenario
  Future<void> addScenario({
    required String name,
    required String text,
    required int priority,
  }) async {
    print('MqttViewModel | addScenario success');
  }

  /// MqttType.addTag
  Future<void> addTag({
    required String thing,
    required String? service,
    required String tag,
  }) async {
    print('MqttViewModel | addTag success');
  }
}

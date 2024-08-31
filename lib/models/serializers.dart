import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:sr/models/appstate.dart';
import 'package:sr/models/disaster_update.dart';
import 'package:sr/models/distress.dart';
import 'package:sr/models/users.dart';

part 'serializers.g.dart';

@SerializersFor([
  // TODO: add the built values that require serialization
  Appstate, Distress, DisasterUpdate, Users
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

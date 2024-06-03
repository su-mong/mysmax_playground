enum WeatherState {
  thunderstorm(title: "천둥", value: 'thunderstorm'),
  drizzle(title: "이슬비", value: 'drizzle'),
  rain(title: "비", value: 'rain'),
  snow(title: "눈", value: 'snow'),
  mist(title: "엷은 안개", value: 'mist'),
  smoke(title: "연기 구름", value: 'smoke'),
  haze(title: "연무", value: 'haze'),
  dust(title: "먼지", value: 'dust'),
  fog(title: "안개", value: 'fog'),
  sand(title: "모래", value: 'sand'),
  ash(title: "재", value: 'ash'),
  squall(title: "돌풍", value: 'squall'),
  tornado(title: "토네이도", value: 'tornado'),
  clear(title: "맑음", value: 'clear'),
  clouds(title: "구름", value: 'clouds');

  final String title;
  final String value;
  const WeatherState({
    required this.title,
    required this.value,
  });
}

extension WeatherStateExtension on String {
  WeatherState get toWeatherStateFromValue {
    print('?SADFSA? ${this}');

    switch(this) {
      case 'thunderstorm':
        return WeatherState.thunderstorm;
      case 'drizzle':
        return WeatherState.drizzle;
      case 'rain':
        return WeatherState.rain;
      case 'snow':
        return WeatherState.snow;
      case 'mist':
        return WeatherState.mist;
      case 'smoke':
        return WeatherState.smoke;
      case 'haze':
        return WeatherState.haze;
      case 'dust':
        return WeatherState.dust;
      case 'fog':
        return WeatherState.fog;
      case 'sand':
        return WeatherState.sand;
      case 'ash':
        return WeatherState.ash;
      case 'squall':
        return WeatherState.squall;
      case 'tornado':
        return WeatherState.tornado;
      case 'clear':
        return WeatherState.clear;
      case 'clouds':
        return WeatherState.clouds;
      default:
        throw Exception('This is not a value for WeatherState');
    }
  }
}
/// Russian captions for TMDB person departments.
extension PersonDepartmentLabel on String {
  /// Label for this department, or the original text.
  String toDepartmentLabel() {
    return switch (this) {
      'Acting' => 'Актёрское искусство',
      'Directing' => 'Режиссура',
      'Writing' => 'Сценарий',
      'Production' => 'Продюсирование',
      'Sound' => 'Звук',
      'Camera' => 'Камера',
      'Editing' => 'Монтаж',
      'Art' => 'Художественный отдел',
      'Costume & Make-Up' => 'Костюмы и грим',
      'Visual Effects' => 'Визуальные эффекты',
      'Crew' => 'Съёмочная группа',
      'Lighting' => 'Свет',
      'Creator' => 'Создатель',
      _ => this,
    };
  }
}

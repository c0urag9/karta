class Company {
  final String id;
  final String name;
  final String inn;
  final String industry;
  final String legalForm;
  final String foundedYear;
  final String region;
  final String description;

  const Company({
    required this.id,
    required this.name,
    this.inn = '',
    this.industry = '',
    this.legalForm = '',
    this.foundedYear = '',
    this.region = '',
    this.description = '',
  });

  factory Company.fromMap(Map<String, dynamic> map) => Company(
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    inn: map['inn'] ?? '',
    industry: map['industry'] ?? '',
    legalForm: map['legalForm'] ?? '',
    foundedYear: map['foundedYear'] ?? '',
    region: map['region'] ?? '',
    description: map['description'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id, 'name': name, 'inn': inn, 'industry': industry,
    'legalForm': legalForm, 'foundedYear': foundedYear,
    'region': region, 'description': description,
  };
}

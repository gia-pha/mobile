import 'package:gia_pha_mobile/model/FamilyMember.dart';

/// Utility class for genogram-related functions
class GenogramUtils {
  /// Generate sample family data for the genogram with relationship statuses and adoption types
  static List<FamilyMember> getSampleFamilyDataWithStatuses() {
    // Start with the basic family data
    final familyMembers = getSampleFamilyData();

    // Add relationship statuses
    for (var member in familyMembers) {
      switch (member.id) {
        // Add divorce status to one couple
        case 'f1':
          member.extraData['relationships'] = {
            'm1': {'status': 'divorced'},
          };
          break;
        case 'm1':
          member.extraData['relationships'] = {
            'f1': {'status': 'divorced'},
          };
          break;

        // Add separation status to another couple
        case 'f2':
          member.extraData['relationships'] = {
            'm3': {'status': 'separated'},
          };
          break;
        case 'm3':
          member.extraData['relationships'] = {
            'f2': {'status': 'separated'},
          };
          break;

        // Add engagement status
        case 'c3':
          member.extraData['relationships'] = {
            'sp3': {'status': 'engaged'},
          };
          break;
        case 'sp3':
          member.extraData['relationships'] = {
            'c3': {'status': 'engaged'},
          };
          break;
      }

      // Add adoption statuses
      switch (member.id) {
        case 'gc3': // Third grandchild as adopted
          member.extraData['adoptionStatus'] = 'adopted';
          break;
        case 'gc4': // Fourth grandchild as foster
          member.extraData['adoptionStatus'] = 'foster';
          break;
      }
    }

    return familyMembers;
  }

  /// Generate sample family data for the genogram
  static List<FamilyMember> getSampleFamilyData() {
    return [
      // Grandparents - First Generation
      FamilyMember(
        id: 'gf1',
        name: 'Robert Smith',
        gender: 0,
        spouses: ['gm1'],
        // relationshipTypes: {'gm1': RelationshipType.married},
        isDeceased: true,
        dateOfBirth: DateTime(1920),
        dateOfDeath: DateTime(1990),
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_1.png',
        kinship: 'Father',
        extraData: {'occupation': 'Farmer', 'hobbies': ['Fishing', 'Gardening'], 'medicalHistory': 'Diabetes' },
      ),
      FamilyMember(
        id: 'gm1',
        name: 'Mary Smith',
        gender: 1,
        spouses: ['gf1'],
        // relationshipTypes: {'gf1': RelationshipType.married},
        isDeceased: true,
        dateOfBirth: DateTime(1925),
        dateOfDeath: DateTime(1995),
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_2.png',
        kinship: 'Mother',
        extraData: {'occupation': 'Teacher', 'hobbies': ['Knitting', 'Reading'], 'medicalHistory': 'Hypertension' },
      ),

      // First generation - Other side
      FamilyMember(
        id: 'gf2',
        name: 'James Johnson',
        gender: 0,
        spouses: ['gm2', 'gm2b'],
        // relationshipTypes: {
        //   'gm2': RelationshipType.divorced,
        //   'gm2b': RelationshipType.married,
        // },
        isDeceased: true,
        dateOfBirth: DateTime(1918),
        dateOfDeath: DateTime(1985),
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_3.png',
        kinship: 'Son',
        extraData: {'occupation': 'Engineer', 'hobbies': ['Traveling', 'Cooking'], 'medicalHistory': 'Asthma' },
      ),
      FamilyMember(
        id: 'gm2',
        name: 'Emma Johnson',
        gender: 1,
        spouses: ['gf2'],
        // relationshipTypes: {'gf2': RelationshipType.divorced},
        dateOfBirth: DateTime(1922),
        dateOfDeath: DateTime(2000),
        isDeceased: true,
        //avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_4.png',
        kinship: 'Daughter',
        extraData: {'occupation': 'Nurse', 'hobbies': ['Painting', 'Dancing'], 'medicalHistory': 'None' },
      ),
      FamilyMember(
        id: 'gm2b',
        name: 'Helen Johnson',
        gender: 1,
        spouses: ['gf2'],
        // relationshipTypes: {'gf2': RelationshipType.married},
        dateOfBirth: DateTime(1930),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_5.png',
        kinship: 'Brother',
      ),

      // Second generation - Parents
      FamilyMember(
        id: 'f1',
        name: 'John Smith',
        gender: 0,
        fatherId: 'gf1',
        motherId: 'gm1',
        spouses: ['m1', 'm2', 'm3', 'm4'],
        // relationshipTypes: {'m1': RelationshipType.married},
        dateOfBirth: DateTime(1950),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_6.png',
        kinship: 'Sister',
      ),
      FamilyMember(
        id: 'm1',
        name: 'Sarah Smith',
        gender: 1,
        fatherId: 'gf2',
        motherId: 'gm2',
        spouses: ['f1'],
        // relationshipTypes: {'f1': RelationshipType.married},
        dateOfBirth: DateTime(1952),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_7.png',
        kinship: 'Husband',
      ),
      FamilyMember(
        id: 'm2',
        name: 'Sarah Smith',
        gender: 1,
        // fatherId: 'gf2',
        // motherId: 'gm2',
        spouses: ['f1'],
        // relationshipTypes: {'f1': RelationshipType.married},
        dateOfBirth: DateTime(1952),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_8.png',
        kinship: 'Wife',
      ),
      FamilyMember(
        id: 'm3',
        name: 'Sarah Smith',
        gender: 1,
        // fatherId: 'gf2',
        // motherId: 'gm2',
        spouses: ['f1'],
        // relationshipTypes: {'f1': RelationshipType.married},
        dateOfBirth: DateTime(1952),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_9.png',
        kinship: 'Uncle',
      ),
      FamilyMember(
        id: 'm4',
        name: 'Sarah Smith',
        gender: 1,
        // fatherId: 'gf2',
        // motherId: 'gm2',
        spouses: ['f1'],
        // relationshipTypes: {'f1': RelationshipType.married},
        dateOfBirth: DateTime(1952),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_10.png',
        kinship: 'Aunt',
      ),

      // Uncle with multiple marriages
      FamilyMember(
        id: 'u2241',
        name: 'Thomas Smith',
        gender: 0,
        fatherId: 'gf1',
        motherId: 'gm1',
        // spouses: ['a1', 'a2'],
        // relationshipTypes: {
        //   'a1': RelationshipType.divorced,
        //   'a2': RelationshipType.married
        // },
        dateOfBirth: DateTime(1955),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_11.png',
        kinship: 'Nephew',
      ),
      FamilyMember(
        id: 'u201',
        name: 'Thomas Smith',
        gender: 0,
        fatherId: 'gf1',
        motherId: 'gm1',
        // spouses: ['a1', 'a2'],
        // relationshipTypes: {
        //   'a1': RelationshipType.divorced,
        //   'a2': RelationshipType.married
        // },
        dateOfBirth: DateTime(1955),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_12.png',
        kinship: 'Niece',
      ),
      FamilyMember(
        id: 'u2901',
        name: 'Thomas Smith',
        gender: 0,
        fatherId: 'gf1',
        motherId: 'gm1',
        // spouses: ['a1', 'a2'],
        // relationshipTypes: {
        //   'a1': RelationshipType.divorced,
        //   'a2': RelationshipType.married
        // },
        dateOfBirth: DateTime(1955),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_13.png',
        kinship: 'Cousin',
      ),
      FamilyMember(
        id: 'u-21',
        name: 'Thomas Smith',
        gender: 0,
        fatherId: 'gf1',
        motherId: 'gm1',
        // spouses: ['a1', 'a2'],
        // relationshipTypes: {
        //   'a1': RelationshipType.divorced,
        //   'a2': RelationshipType.married
        // },
        dateOfBirth: DateTime(1955),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_14.png',
        kinship: 'Grandfather',
      ),
      FamilyMember(
        id: 'u219=',
        name: 'Thomas Smith',
        gender: 0,
        fatherId: 'gf1',
        motherId: 'gm1',
        // spouses: ['a1', 'a2'],
        // relationshipTypes: {
        //   'a1': RelationshipType.divorced,
        //   'a2': RelationshipType.married
        // },
        dateOfBirth: DateTime(1955),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_15.png',
        kinship: 'Grandmother',
      ),
      FamilyMember(
        id: 'u21',
        name: 'Thomas Smith',
        gender: 0,
        fatherId: 'gf1',
        motherId: 'gm1',
        // spouses: ['a1', 'a2'],
        // relationshipTypes: {
        //   'a1': RelationshipType.divorced,
        //   'a2': RelationshipType.married
        // },
        dateOfBirth: DateTime(1955),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_16.png',
        kinship: 'Grandson',
      ),
      FamilyMember(
        id: 'u212',
        name: 'Thomas Smith',
        gender: 0,
        fatherId: 'gf1',
        motherId: 'gm1',
        // spouses: ['a1', 'a2'],
        // relationshipTypes: {
        //   'a1': RelationshipType.divorced,
        //   'a2': RelationshipType.married
        // },
        dateOfBirth: DateTime(1955),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_17.png',
        kinship: 'Granddaughter',
      ),
      // Uncle with multiple marriages
      FamilyMember(
        id: 'u1',
        name: 'Thomas Smith',
        gender: 0,
        fatherId: 'gf1',
        motherId: 'gm1',
        spouses: ['a1', 'a2'],
        // relationshipTypes: {
        //   'a1': RelationshipType.divorced,
        //   'a2': RelationshipType.married
        // },
        dateOfBirth: DateTime(1955),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_18.png',
        kinship: 'Father-in-law',
      ),
      FamilyMember(
        id: 'a1',
        name: 'Patricia',
        gender: 1,
        spouses: ['u1'],
        // relationshipTypes: {'u1': RelationshipType.divorced},
        dateOfBirth: DateTime(1958),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_19.png',
        kinship: 'Mother-in-law',
      ),
      FamilyMember(
        id: 'a2',
        name: 'Jennifer',
        gender: 1,
        spouses: ['u1'],
        // relationshipTypes: {'u1': RelationshipType.married},
        dateOfBirth: DateTime(1960),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/3d_1.png',
        kinship: 'Son-in-law',
      ),

      // Aunt from second marriage
      FamilyMember(
        id: 'a3',
        name: 'Barbara Johnson',
        gender: 1,
        fatherId: 'gf2',
        motherId: 'gm2b',
        dateOfBirth: DateTime(1962),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/3d_2.png',
        kinship: 'Daughter-in-law',
      ),

      // Third generation - Siblings including twins
      FamilyMember(
        id: 'c1',
        name: 'Michael Smith',
        gender: 0,
        fatherId: 'f1',
        motherId: 'm1',
        dateOfBirth: DateTime(1975),
        isDeceased: false,
        spouses: ['p1'],
        // relationshipTypes: {'p1': RelationshipType.married},
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/3d_3.png',
        kinship: 'Brother-in-law',
      ),
      FamilyMember(
        id: 'c2',
        name: 'David Smith',
        gender: 0,
        fatherId: 'f1',
        motherId: 'm1',
        dateOfBirth: DateTime(1980),
        isDeceased: false,
        // birthType: BirthType.identical,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/3d_4.png',
        kinship: 'Sister-in-law',
        // ,
      ),
      FamilyMember(
        id: 'c3',
        name: 'Daniel Smith',
        gender: 0,
        fatherId: 'f1',
        motherId: 'm1',
        dateOfBirth: DateTime(1980),
        isDeceased: false,
        // birthType: BirthType.identical,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/3d_5.png',
        kinship: 'Stepfather',
      ),
      FamilyMember(
        id: 'c4',
        name: 'Emily Smith',
        gender: 1,
        fatherId: 'f1',
        motherId: 'm1',
        dateOfBirth: DateTime(1985),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_1.png',
        kinship: 'Stepmother',
      ),

      // Cousins from uncle's first marriage
      FamilyMember(
        id: 'c5',
        name: 'Jessica',
        gender: 1,
        fatherId: 'u1',
        motherId: 'a1',
        dateOfBirth: DateTime(1978),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_2.png',
        kinship: 'Stepson',
      ),

      // Cousins from uncle's second marriage - Fraternal twins
      FamilyMember(
        id: 'c6',
        name: 'Matthew',
        gender: 0,
        fatherId: 'u1',
        motherId: 'a2',
        dateOfBirth: DateTime(1988),
        isDeceased: false,
        // birthType: BirthType.fraternal,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_3.png',
        kinship: 'Stepdaughter',
        // ,
      ),
      FamilyMember(
        id: 'c7',
        name: 'Olivia',
        gender: 1,
        fatherId: 'u1',
        motherId: 'a2',
        dateOfBirth: DateTime(1988),
        isDeceased: false,
        // birthType: BirthType.fraternal,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_4.png',
        kinship: 'Half-brother',
        // ,
      ),

      // Fourth generation
      FamilyMember(
        id: 'p1',
        name: 'Amanda Smith',
        gender: 1,
        spouses: ['c1'],
        // relationshipTypes: {'c1': RelationshipType.married},
        dateOfBirth: DateTime(1978),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_5.png',
        kinship: 'Half-sister',
      ),
      FamilyMember(
        id: 'gc1',
        name: 'Sophia Smith',
        gender: 1,
        fatherId: 'c1',
        motherId: 'p1',
        dateOfBirth: DateTime(2005),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_6.png',
        kinship: 'Ancestor',
      ),
      FamilyMember(
        id: 'gc2',
        name: 'JJJ',
        // spouses: ['45gc1'],
        gender: 0,
        dateOfBirth: DateTime(2008),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_7.png',
        kinship: 'Descendant',
      ),
      FamilyMember(
        id: '45gc1',
        name: 'FFF',
        gender: 1,
        // spouses: ['gc2'],
        dateOfBirth: DateTime(2005),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_8.png',
        kinship: 'Relative',
      ),
      FamilyMember(
        id: 'gc542',
        name: 'CCC',
        gender: 0,
        motherId: '45gc1',
        fatherId: 'gc2',
        dateOfBirth: DateTime(2008),
        isDeceased: false,
        avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_9.png',
        kinship: 'Kin',
      ),
    ];
  }

  /// Get the formatted age text of a family member
  static String getAgeText(FamilyMember member) {
    if (member.dateOfBirth == null) {
      return '';
    }

    final now = DateTime.now();
    DateTime endDate = member.isDeceased && member.dateOfDeath != null
        ? member.dateOfDeath!
        : now;

    int age = endDate.year - member.dateOfBirth!.year;
    if (endDate.month < member.dateOfBirth!.month ||
        (endDate.month == member.dateOfBirth!.month &&
            endDate.day < member.dateOfBirth!.day)) {
      age--;
    }

    if (member.isDeceased) {
      return '$age years (deceased)';
    }
    return '$age years';
  }

  /// Get formatted date text
  static String formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    return '${date.month}/${date.day}/${date.year}';
  }
}

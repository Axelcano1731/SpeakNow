import 'package:flutter/material.dart';

import '../models/models.dart';

/// Curso MVP: inglés para hispanohablantes.
/// 4 unidades, 3 lecciones por unidad, ejercicios mixtos.
class CourseData {
  CourseData._();

  static final List<Unit> units = [
    _unit1,
    _unit2,
    _unit3,
    _unit4,
  ];

  static Lesson? lessonById(String id) {
    for (final unit in units) {
      for (final lesson in unit.lessons) {
        if (lesson.id == id) return lesson;
      }
    }
    return null;
  }

  static List<Lesson> get allLessons =>
      units.expand((u) => u.lessons).toList();

  // ---------------------------------------------------------------- Unidad 1
  static final Unit _unit1 = Unit(
    id: 'u1',
    title: 'Unidad 1',
    subtitle: 'Saludos y presentaciones',
    color: const Color(0xFF4C2882),
    lessons: [
      Lesson(
        id: 'u1l1',
        title: 'Saludos',
        emoji: '👋',
        exercises: [
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Cómo se dice "Hola"?',
            answer: 'Hello',
            options: [
              CardOption('Hello', emoji: '👋'),
              CardOption('Goodbye', emoji: '🚪'),
              CardOption('Please', emoji: '🙏'),
              CardOption('Sorry', emoji: '😅'),
            ],
          ),
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Qué significa "Good morning"?',
            answer: 'Buenos días',
            options: [
              CardOption('Buenos días', emoji: '🌅'),
              CardOption('Buenas noches', emoji: '🌙'),
              CardOption('Buenas tardes', emoji: '🌇'),
              CardOption('Hasta luego', emoji: '👋'),
            ],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona lo que oíste',
            audioText: 'Good night',
            answer: 'Good night',
            options: [
              CardOption('Good night', emoji: '🌙'),
              CardOption('Good morning', emoji: '🌅'),
              CardOption('Goodbye', emoji: '👋'),
              CardOption('Good luck', emoji: '🍀'),
            ],
          ),
          const Exercise(
            type: ExerciseType.speak,
            prompt: 'Di esta frase en voz alta',
            audioText: 'Hello, good morning!',
            answer: 'Hello, good morning',
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Buenas tardes"',
            answer: 'Good afternoon',
          ),
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Cómo te despides diciendo "Adiós"?',
            answer: 'Goodbye',
            options: [
              CardOption('Goodbye', emoji: '👋'),
              CardOption('Welcome', emoji: '🤗'),
              CardOption('Hello', emoji: '😀'),
              CardOption('Thanks', emoji: '🙏'),
            ],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona el significado',
            audioText: 'See you later',
            answer: 'Hasta luego',
            options: [
              CardOption('Hasta luego', emoji: '👋'),
              CardOption('Buenos días', emoji: '🌅'),
              CardOption('Mucho gusto', emoji: '🤝'),
              CardOption('Bienvenido', emoji: '🤗'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Buenas noches"',
            answer: 'Good night',
            alternatives: ['Good evening'],
          ),
        ],
      ),
      Lesson(
        id: 'u1l2',
        title: 'Presentaciones',
        emoji: '🤝',
        exercises: [
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Cómo preguntas el nombre de alguien?',
            answer: 'What is your name?',
            options: [
              CardOption('What is your name?', emoji: '❓'),
              CardOption('How old are you?', emoji: '🎂'),
              CardOption('Where are you from?', emoji: '🌍'),
              CardOption('How are you?', emoji: '🙂'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Mi nombre es Ana"',
            answer: 'My name is Ana',
            alternatives: ["I'm Ana", 'I am Ana'],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona lo que oíste',
            audioText: 'Nice to meet you',
            answer: 'Nice to meet you',
            options: [
              CardOption('Nice to meet you', emoji: '🤝'),
              CardOption('Nice to see you', emoji: '👀'),
              CardOption('How are you?', emoji: '🙂'),
              CardOption('Where are you?', emoji: '📍'),
            ],
          ),
          const Exercise(
            type: ExerciseType.speak,
            prompt: 'Preséntate diciendo esta frase',
            audioText: 'My name is Alex, nice to meet you',
            answer: 'My name is Alex, nice to meet you',
          ),
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Qué significa "Where are you from?"',
            answer: '¿De dónde eres?',
            options: [
              CardOption('¿De dónde eres?', emoji: '🌍'),
              CardOption('¿Cómo estás?', emoji: '🙂'),
              CardOption('¿Cuántos años tienes?', emoji: '🎂'),
              CardOption('¿Dónde vives?', emoji: '🏠'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Yo soy de México"',
            answer: 'I am from Mexico',
            alternatives: ["I'm from Mexico"],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona el significado',
            audioText: 'How are you?',
            answer: '¿Cómo estás?',
            options: [
              CardOption('¿Cómo estás?', emoji: '🙂'),
              CardOption('¿Quién eres?', emoji: '👤'),
              CardOption('¿Qué haces?', emoji: '💼'),
              CardOption('¿Dónde estás?', emoji: '📍'),
            ],
          ),
          const Exercise(
            type: ExerciseType.speak,
            prompt: 'Responde en voz alta',
            audioText: 'I am fine, thank you',
            answer: 'I am fine, thank you',
          ),
        ],
      ),
      Lesson(
        id: 'u1l3',
        title: 'Cortesía',
        emoji: '🙏',
        exercises: [
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Cómo se dice "Por favor"?',
            answer: 'Please',
            options: [
              CardOption('Please', emoji: '🙏'),
              CardOption('Thanks', emoji: '💜'),
              CardOption('Sorry', emoji: '😔'),
              CardOption('Excuse me', emoji: '🙋'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Muchas gracias"',
            answer: 'Thank you very much',
            alternatives: ['Thanks a lot', 'Thank you so much'],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona lo que oíste',
            audioText: 'Excuse me',
            answer: 'Excuse me',
            options: [
              CardOption('Excuse me', emoji: '🙋'),
              CardOption('Forgive me', emoji: '😔'),
              CardOption('Listen to me', emoji: '👂'),
              CardOption('Help me', emoji: '🆘'),
            ],
          ),
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Qué respondes a "Thank you"?',
            answer: "You're welcome",
            options: [
              CardOption("You're welcome", emoji: '😊'),
              CardOption('Please', emoji: '🙏'),
              CardOption('Excuse me', emoji: '🙋'),
              CardOption('Me too', emoji: '👥'),
            ],
          ),
          const Exercise(
            type: ExerciseType.speak,
            prompt: 'Di esta frase en voz alta',
            audioText: 'Excuse me, can you help me, please?',
            answer: 'Excuse me, can you help me, please',
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Lo siento"',
            answer: 'I am sorry',
            alternatives: ["I'm sorry", 'Sorry'],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona el significado',
            audioText: 'No problem',
            answer: 'No hay problema',
            options: [
              CardOption('No hay problema', emoji: '👌'),
              CardOption('No lo sé', emoji: '🤷'),
              CardOption('No entiendo', emoji: '😕'),
              CardOption('No gracias', emoji: '🙅'),
            ],
          ),
        ],
      ),
    ],
  );

  // ---------------------------------------------------------------- Unidad 2
  static final Unit _unit2 = Unit(
    id: 'u2',
    title: 'Unidad 2',
    subtitle: 'Comida y bebidas',
    color: const Color(0xFF800080),
    lessons: [
      Lesson(
        id: 'u2l1',
        title: 'En el café',
        emoji: '☕',
        exercises: [
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Cómo se dice "café"?',
            answer: 'Coffee',
            options: [
              CardOption('Coffee', emoji: '☕'),
              CardOption('Tea', emoji: '🍵'),
              CardOption('Milk', emoji: '🥛'),
              CardOption('Juice', emoji: '🧃'),
            ],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona lo que oíste',
            audioText: 'A cup of tea, please',
            answer: 'A cup of tea, please',
            options: [
              CardOption('A cup of tea, please', emoji: '🍵'),
              CardOption('A cup of coffee, please', emoji: '☕'),
              CardOption('A glass of water, please', emoji: '💧'),
              CardOption('A bottle of juice, please', emoji: '🧃'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Quiero un café, por favor"',
            answer: 'I want a coffee, please',
            alternatives: ['I would like a coffee, please'],
          ),
          const Exercise(
            type: ExerciseType.speak,
            prompt: 'Pide en voz alta',
            audioText: 'I would like a coffee with milk',
            answer: 'I would like a coffee with milk',
          ),
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Qué significa "water"?',
            answer: 'Agua',
            options: [
              CardOption('Agua', emoji: '💧'),
              CardOption('Vino', emoji: '🍷'),
              CardOption('Leche', emoji: '🥛'),
              CardOption('Jugo', emoji: '🧃'),
            ],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona el significado',
            audioText: 'The check, please',
            answer: 'La cuenta, por favor',
            options: [
              CardOption('La cuenta, por favor', emoji: '🧾'),
              CardOption('El menú, por favor', emoji: '📋'),
              CardOption('Un postre, por favor', emoji: '🍰'),
              CardOption('La propina, por favor', emoji: '💵'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Un té, por favor"',
            answer: 'A tea, please',
            alternatives: ['One tea, please', 'A cup of tea, please'],
          ),
        ],
      ),
      Lesson(
        id: 'u2l2',
        title: 'Frutas y comida',
        emoji: '🍎',
        exercises: [
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Cómo se dice "manzana"?',
            answer: 'Apple',
            options: [
              CardOption('Apple', emoji: '🍎'),
              CardOption('Orange', emoji: '🍊'),
              CardOption('Banana', emoji: '🍌'),
              CardOption('Grape', emoji: '🍇'),
            ],
          ),
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Qué significa "bread"?',
            answer: 'Pan',
            options: [
              CardOption('Pan', emoji: '🍞'),
              CardOption('Queso', emoji: '🧀'),
              CardOption('Arroz', emoji: '🍚'),
              CardOption('Huevo', emoji: '🥚'),
            ],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona lo que oíste',
            audioText: 'I eat an apple every day',
            answer: 'I eat an apple every day',
            options: [
              CardOption('I eat an apple every day', emoji: '🍎'),
              CardOption('I eat an orange every day', emoji: '🍊'),
              CardOption('I drink milk every day', emoji: '🥛'),
              CardOption('I eat bread every day', emoji: '🍞'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Me gusta el pan con queso"',
            answer: 'I like bread with cheese',
          ),
          const Exercise(
            type: ExerciseType.speak,
            prompt: 'Di esta frase en voz alta',
            audioText: 'I like apples and bananas',
            answer: 'I like apples and bananas',
          ),
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Cómo se dice "desayuno"?',
            answer: 'Breakfast',
            options: [
              CardOption('Breakfast', emoji: '🍳'),
              CardOption('Lunch', emoji: '🥪'),
              CardOption('Dinner', emoji: '🍽️'),
              CardOption('Snack', emoji: '🍿'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "El desayuno es delicioso"',
            answer: 'Breakfast is delicious',
            alternatives: ['The breakfast is delicious'],
          ),
        ],
      ),
      Lesson(
        id: 'u2l3',
        title: 'En el restaurante',
        emoji: '🍽️',
        exercises: [
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Cómo pides el menú?',
            answer: 'The menu, please',
            options: [
              CardOption('The menu, please', emoji: '📋'),
              CardOption('The door, please', emoji: '🚪'),
              CardOption('The table, please', emoji: '🪑'),
              CardOption('The kitchen, please', emoji: '👨‍🍳'),
            ],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona lo que oíste',
            audioText: 'A table for two, please',
            answer: 'A table for two, please',
            options: [
              CardOption('A table for two, please', emoji: '👥'),
              CardOption('A table for four, please', emoji: '👨‍👩‍👧‍👦'),
              CardOption('A chair for me, please', emoji: '🪑'),
              CardOption('A room for two, please', emoji: '🛏️'),
            ],
          ),
          const Exercise(
            type: ExerciseType.speak,
            prompt: 'Ordena en voz alta',
            audioText: 'I want chicken with rice, please',
            answer: 'I want chicken with rice, please',
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "La comida está deliciosa"',
            answer: 'The food is delicious',
          ),
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Qué significa "I am hungry"?',
            answer: 'Tengo hambre',
            options: [
              CardOption('Tengo hambre', emoji: '😋'),
              CardOption('Tengo sed', emoji: '🥤'),
              CardOption('Estoy lleno', emoji: '😌'),
              CardOption('Tengo prisa', emoji: '🏃'),
            ],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona el significado',
            audioText: 'It is very tasty',
            answer: 'Está muy sabroso',
            options: [
              CardOption('Está muy sabroso', emoji: '😋'),
              CardOption('Está muy caliente', emoji: '🔥'),
              CardOption('Está muy frío', emoji: '🧊'),
              CardOption('Está muy caro', emoji: '💸'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "La cuenta, por favor"',
            answer: 'The check, please',
            alternatives: ['The bill, please'],
          ),
        ],
      ),
    ],
  );

  // ---------------------------------------------------------------- Unidad 3
  static final Unit _unit3 = Unit(
    id: 'u3',
    title: 'Unidad 3',
    subtitle: 'Viajes y direcciones',
    color: const Color(0xFF6A3AB2),
    lessons: [
      Lesson(
        id: 'u3l1',
        title: 'En el aeropuerto',
        emoji: '✈️',
        exercises: [
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Cómo se dice "avión"?',
            answer: 'Airplane',
            options: [
              CardOption('Airplane', emoji: '✈️'),
              CardOption('Train', emoji: '🚆'),
              CardOption('Bus', emoji: '🚌'),
              CardOption('Ship', emoji: '🚢'),
            ],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona lo que oíste',
            audioText: 'Where is my gate?',
            answer: 'Where is my gate?',
            options: [
              CardOption('Where is my gate?', emoji: '🚪'),
              CardOption('Where is my seat?', emoji: '💺'),
              CardOption('Where is my bag?', emoji: '🧳'),
              CardOption('Where is my ticket?', emoji: '🎫'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Mi pasaporte, por favor"',
            answer: 'My passport, please',
          ),
          const Exercise(
            type: ExerciseType.speak,
            prompt: 'Di esta frase en voz alta',
            audioText: 'I have a ticket to New York',
            answer: 'I have a ticket to New York',
          ),
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Qué significa "luggage"?',
            answer: 'Equipaje',
            options: [
              CardOption('Equipaje', emoji: '🧳'),
              CardOption('Boleto', emoji: '🎫'),
              CardOption('Asiento', emoji: '💺'),
              CardOption('Pasaporte', emoji: '🛂'),
            ],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona el significado',
            audioText: 'The flight is delayed',
            answer: 'El vuelo está retrasado',
            options: [
              CardOption('El vuelo está retrasado', emoji: '⏰'),
              CardOption('El vuelo fue cancelado', emoji: '❌'),
              CardOption('El vuelo está a tiempo', emoji: '✅'),
              CardOption('El vuelo ya salió', emoji: '🛫'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "¿Dónde está mi maleta?"',
            answer: 'Where is my suitcase?',
            alternatives: ['Where is my luggage?', 'Where is my bag?'],
          ),
        ],
      ),
      Lesson(
        id: 'u3l2',
        title: 'Direcciones',
        emoji: '🗺️',
        exercises: [
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Cómo se dice "izquierda"?',
            answer: 'Left',
            options: [
              CardOption('Left', emoji: '⬅️'),
              CardOption('Right', emoji: '➡️'),
              CardOption('Straight', emoji: '⬆️'),
              CardOption('Back', emoji: '⬇️'),
            ],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona lo que oíste',
            audioText: 'Turn right at the corner',
            answer: 'Turn right at the corner',
            options: [
              CardOption('Turn right at the corner', emoji: '➡️'),
              CardOption('Turn left at the corner', emoji: '⬅️'),
              CardOption('Go straight ahead', emoji: '⬆️'),
              CardOption('Stop at the corner', emoji: '🛑'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "¿Dónde está el banco?"',
            answer: 'Where is the bank?',
          ),
          const Exercise(
            type: ExerciseType.speak,
            prompt: 'Pregunta en voz alta',
            audioText: 'How do I get to the museum?',
            answer: 'How do I get to the museum',
          ),
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Qué significa "near"?',
            answer: 'Cerca',
            options: [
              CardOption('Cerca', emoji: '📍'),
              CardOption('Lejos', emoji: '🔭'),
              CardOption('Arriba', emoji: '⬆️'),
              CardOption('Abajo', emoji: '⬇️'),
            ],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona el significado',
            audioText: 'The hotel is far from here',
            answer: 'El hotel está lejos de aquí',
            options: [
              CardOption('El hotel está lejos de aquí', emoji: '🔭'),
              CardOption('El hotel está cerca de aquí', emoji: '📍'),
              CardOption('El hotel está cerrado', emoji: '🔒'),
              CardOption('El hotel es muy caro', emoji: '💸'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Gira a la izquierda"',
            answer: 'Turn left',
          ),
        ],
      ),
      Lesson(
        id: 'u3l3',
        title: 'En el hotel',
        emoji: '🏨',
        exercises: [
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Cómo se dice "habitación"?',
            answer: 'Room',
            options: [
              CardOption('Room', emoji: '🛏️'),
              CardOption('Key', emoji: '🔑'),
              CardOption('Floor', emoji: '🏢'),
              CardOption('Door', emoji: '🚪'),
            ],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona lo que oíste',
            audioText: 'I have a reservation',
            answer: 'I have a reservation',
            options: [
              CardOption('I have a reservation', emoji: '📅'),
              CardOption('I have a question', emoji: '❓'),
              CardOption('I have a problem', emoji: '⚠️'),
              CardOption('I have a room', emoji: '🛏️'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Una habitación para dos noches"',
            answer: 'A room for two nights',
          ),
          const Exercise(
            type: ExerciseType.speak,
            prompt: 'Di esta frase en voz alta',
            audioText: 'What time is breakfast?',
            answer: 'What time is breakfast',
          ),
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Qué significa "key"?',
            answer: 'Llave',
            options: [
              CardOption('Llave', emoji: '🔑'),
              CardOption('Cama', emoji: '🛏️'),
              CardOption('Toalla', emoji: '🧻'),
              CardOption('Ducha', emoji: '🚿'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "La llave de mi habitación"',
            answer: 'The key to my room',
            alternatives: ['My room key', 'The key of my room'],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona el significado',
            audioText: 'The elevator is on the right',
            answer: 'El ascensor está a la derecha',
            options: [
              CardOption('El ascensor está a la derecha', emoji: '🛗'),
              CardOption('El ascensor está a la izquierda', emoji: '⬅️'),
              CardOption('Las escaleras están a la derecha', emoji: '🪜'),
              CardOption('El baño está a la derecha', emoji: '🚻'),
            ],
          ),
        ],
      ),
    ],
  );

  // ---------------------------------------------------------------- Unidad 4
  static final Unit _unit4 = Unit(
    id: 'u4',
    title: 'Unidad 4',
    subtitle: 'Familia y vida diaria',
    color: const Color(0xFF9B4DCA),
    lessons: [
      Lesson(
        id: 'u4l1',
        title: 'La familia',
        emoji: '👨‍👩‍👧‍👦',
        exercises: [
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Cómo se dice "madre"?',
            answer: 'Mother',
            options: [
              CardOption('Mother', emoji: '👩'),
              CardOption('Father', emoji: '👨'),
              CardOption('Sister', emoji: '👧'),
              CardOption('Brother', emoji: '👦'),
            ],
          ),
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Qué significa "brother"?',
            answer: 'Hermano',
            options: [
              CardOption('Hermano', emoji: '👦'),
              CardOption('Hermana', emoji: '👧'),
              CardOption('Primo', emoji: '🧑'),
              CardOption('Abuelo', emoji: '👴'),
            ],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona lo que oíste',
            audioText: 'I have two sisters',
            answer: 'I have two sisters',
            options: [
              CardOption('I have two sisters', emoji: '👭'),
              CardOption('I have two brothers', emoji: '👬'),
              CardOption('I have two cousins', emoji: '🧑‍🤝‍🧑'),
              CardOption('I have two dogs', emoji: '🐶'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Mi padre y mi madre"',
            answer: 'My father and my mother',
            alternatives: ['My dad and my mom'],
          ),
          const Exercise(
            type: ExerciseType.speak,
            prompt: 'Di esta frase en voz alta',
            audioText: 'My family is very big',
            answer: 'My family is very big',
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona el significado',
            audioText: 'My grandmother is very kind',
            answer: 'Mi abuela es muy amable',
            options: [
              CardOption('Mi abuela es muy amable', emoji: '👵'),
              CardOption('Mi abuelo es muy amable', emoji: '👴'),
              CardOption('Mi madre es muy alta', emoji: '👩'),
              CardOption('Mi tía es muy joven', emoji: '👱‍♀️'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Amo a mi familia"',
            answer: 'I love my family',
          ),
        ],
      ),
      Lesson(
        id: 'u4l2',
        title: 'Rutinas diarias',
        emoji: '⏰',
        exercises: [
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Qué significa "I wake up early"?',
            answer: 'Me despierto temprano',
            options: [
              CardOption('Me despierto temprano', emoji: '⏰'),
              CardOption('Me duermo tarde', emoji: '🌙'),
              CardOption('Trabajo mucho', emoji: '💼'),
              CardOption('Corro rápido', emoji: '🏃'),
            ],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona lo que oíste',
            audioText: 'I go to work at eight',
            answer: 'I go to work at eight',
            options: [
              CardOption('I go to work at eight', emoji: '💼'),
              CardOption('I go to school at eight', emoji: '🏫'),
              CardOption('I go to sleep at eight', emoji: '😴'),
              CardOption('I go to the gym at eight', emoji: '🏋️'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Yo estudio inglés todos los días"',
            answer: 'I study English every day',
          ),
          const Exercise(
            type: ExerciseType.speak,
            prompt: 'Di esta frase en voz alta',
            audioText: 'I wake up at seven in the morning',
            answer: 'I wake up at seven in the morning',
          ),
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Cómo se dice "cenar"?',
            answer: 'Have dinner',
            options: [
              CardOption('Have dinner', emoji: '🍽️'),
              CardOption('Have breakfast', emoji: '🍳'),
              CardOption('Have lunch', emoji: '🥪'),
              CardOption('Have a snack', emoji: '🍿'),
            ],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona el significado',
            audioText: 'I watch TV at night',
            answer: 'Veo televisión en la noche',
            options: [
              CardOption('Veo televisión en la noche', emoji: '📺'),
              CardOption('Leo un libro en la noche', emoji: '📖'),
              CardOption('Escucho música en la noche', emoji: '🎧'),
              CardOption('Juego videojuegos en la noche', emoji: '🎮'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Me voy a dormir a las diez"',
            answer: 'I go to sleep at ten',
            alternatives: ['I go to bed at ten'],
          ),
        ],
      ),
      Lesson(
        id: 'u4l3',
        title: 'Pasatiempos',
        emoji: '🎨',
        exercises: [
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Qué significa "I like to read"?',
            answer: 'Me gusta leer',
            options: [
              CardOption('Me gusta leer', emoji: '📖'),
              CardOption('Me gusta correr', emoji: '🏃'),
              CardOption('Me gusta cantar', emoji: '🎤'),
              CardOption('Me gusta bailar', emoji: '💃'),
            ],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona lo que oíste',
            audioText: 'I play soccer on weekends',
            answer: 'I play soccer on weekends',
            options: [
              CardOption('I play soccer on weekends', emoji: '⚽'),
              CardOption('I play tennis on weekends', emoji: '🎾'),
              CardOption('I play music on weekends', emoji: '🎸'),
              CardOption('I play chess on weekends', emoji: '♟️'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Me gusta escuchar música"',
            answer: 'I like to listen to music',
            alternatives: ['I like listening to music'],
          ),
          const Exercise(
            type: ExerciseType.speak,
            prompt: 'Di esta frase en voz alta',
            audioText: 'My favorite hobby is painting',
            answer: 'My favorite hobby is painting',
          ),
          const Exercise(
            type: ExerciseType.selectCard,
            prompt: '¿Cómo se dice "nadar"?',
            answer: 'Swim',
            options: [
              CardOption('Swim', emoji: '🏊'),
              CardOption('Run', emoji: '🏃'),
              CardOption('Jump', emoji: '🤸'),
              CardOption('Dance', emoji: '💃'),
            ],
          ),
          const Exercise(
            type: ExerciseType.listen,
            prompt: 'Escucha y selecciona el significado',
            audioText: 'I love traveling with my friends',
            answer: 'Amo viajar con mis amigos',
            options: [
              CardOption('Amo viajar con mis amigos', emoji: '🌍'),
              CardOption('Amo cocinar con mis amigos', emoji: '🍳'),
              CardOption('Amo estudiar con mis amigos', emoji: '📚'),
              CardOption('Amo cantar con mis amigos', emoji: '🎤'),
            ],
          ),
          const Exercise(
            type: ExerciseType.write,
            prompt: 'Escribe en inglés: "Yo hablo inglés muy bien"',
            answer: 'I speak English very well',
          ),
          const Exercise(
            type: ExerciseType.speak,
            prompt: '¡Última frase! Dila con orgullo',
            audioText: 'I can speak English now!',
            answer: 'I can speak English now',
          ),
        ],
      ),
    ],
  );
}

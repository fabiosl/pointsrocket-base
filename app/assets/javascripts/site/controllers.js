var onRocketSiteApp = angular.module('onRocketSiteApp', []);

var SiteAppCtrl = onRocketSiteApp.controller('SiteAppCtrl', ['$scope', function ($scope) {
  $scope.count=1
  $scope.courses = [
    {'name': 'Criação de Jogos',
     'image': 'assets/static_images/criacao_jogos.png',
     'description': 'Ao final desse curso o aluno será capaz de criar e modificar jogos virtuais 2D e 3D.',
     'age_info': '- Turmas a partir dos 7 anos -',
     'elements': ["Blockly & Scratch", "Minecraft, MCEdit E Computercraft","RPGMaker & Multimedia Fusion ","Unity 3D & Unreal Engine"],
     'classes_options':[ {"name":"Escolha sua turma", "value":"default"}, {"name":"Kids (7 - 9 anos)", "value":"Kids (7 - 9 anos)"},{"name":"Teens 1 (10-12 anos)", "value":"Teens 1 (10-12 anos)"},{"name":"Teens 2 (13 - 15 anos)", "value":"Teens 2 (13 - 15 anos)"},{"name":"Young (16 - 18 anos) ", "value":"Young (16 - 18 anos) "}, {"name":"Outra", "value":"Outra"}],
     'remaining_spots': 32,
     'classes_open': 4
	},
	{'name': 'Criação de Apps',
    'image': 'assets/static_images/criacao_apps.png',
     'description': 'Já imaginou criar um aplicativo ou jogo para smartphone e publicar na App Store?',
     'age_info': '- Turmas a partir dos 10 anos -',
     'elements': ["Como criar um app para Android, iPhone e iPad?","GameSalad & Photoshop", "Mozilla Webmaker", "Unity 3D", "Java & Objective C"],
     'classes_options':[ {"name":"Escolha sua turma", "value":"default"},{"name":"Teens 1 (10-12 anos)", "value":"Teens 1 (10-12 anos)"},{"name":"Teens 2 (13 - 15 anos)", "value":"Teens 2 (13 - 15 anos)"},{"name":"Young (16 - 18 anos) ", "value":"Young (16 - 18 anos) "}, {"name":"Outra", "value":"Outra"}],
     'remaining_spots': 25,
     'classes_open': 2
	},
	{'name': 'Aprendendo a programar',
     'description': 'Quer construir sistemas desktop ou para a internet? Vem com a gente!',
     'image': 'assets/static_images/aprendendo_programar.png',
     'age_info': '- Turmas a partir dos 10 anos -',
     'elements': ["Introdução a programação", "Linguagem Python", "Pygame", "Maratonas de Programação", "Bancos de Dados", "Desenvolvimento Web"],
     'classes_options':[ {"name":"Escolha sua turma", "value":"default"},{"name":"Teens 1 (10-12 anos)", "value":"Teens 1 (10-12 anos)"},{"name":"Teens 2 (13 - 15 anos)", "value":"Teens 2 (13 - 15 anos)"},{"name":"Young (16 - 18 anos) ", "value":"Young (16 - 18 anos) "}, {"name":"Outra", "value":"Outra"}],
     'remaining_spots': 23,
     'classes_open': 2
	},
	// {'name': 'Robótica',
 //     'description': 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Inventore minus, sapiente eligendi repudiandae.',
 //     'age_info': '- Turmas a partir dos 7 anos -',
 //     'elements': ["Lego® Mindstorms", "Lego WeDo", "Vex Robotics", "Arduino", "Robot - Rescue", "Makey Makey"],
 //     'classes_options':[ {"name":"Escolha sua turma", "value":"default"},{"name":"Kids (7 - 9 anos)", "value":"Kids (7 - 9 anos)"},{"name":"Teens 1 (10-12 anos)", "value":"Teens 1 (10-12 anos)"},{"name":"Teens 2 (13 - 15 anos)", "value":"Teens 2 (13 - 15 anos)"},{"name":"Young (16 - 18 anos) ", "value":"Young (16 - 18 anos) "}, {"name":"Outra", "value":"Outra"}],
 //     'remaining_spots': 10,
 //     'classes_open': 2
	// }
  ];

  $scope.changeSelectedCourse = function(course) {
    $scope.selected_course = course;

  }
}]);

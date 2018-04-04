def jobName = '(...)'
Jenkins.instance.getItemByFullName(jobName).builds.findAll { it.result == Result.FAILURE}.each { it.delete() }

Jenkins.instance.getItemByFullName('JobName').builds.findAll { it.number > 10 && it.number < 1717 }.each { it.delete() }

Jenkins.instance.getItemByFullName('VPS - Sunnyvale CA').builds.findAll { it.number < 4070 }.each { it.delete() }

github token
797f6705dff642e75ab3f11d3aec57045d4cdde6
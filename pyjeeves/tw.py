import datetime

from database import Database, DBModel
from plugin import BasePlugin


Database()


class Project(DBModel):
    name = ''

    def __repr__(self):
        return self.name


class ContextSwitch(DBModel):
    project = Project
    description = ''
    timestamp = 0

    def __repr__(self):
        timestamp = datetime.datetime.fromtimestamp(self.timestamp)
        return '{}: {}'.format(self.description, timestamp)


class Plugin(BasePlugin):
    '''
    register context switches
    '''
    def run_command(self, args):
        if not args:
            return self._print_switches()

        if args == ['--reset']:
            for switch in ContextSwitch.find():
                switch.delete()
            for project in Project.find():
                project.delete()
            return

        if len(args) < 2:
            return

        project_name, *description = args
        description = ' '.join(description)

        projects = Project.find(name=project_name)
        if not projects:
            Project(name=project_name).save()
            projects = Project.find(name=project_name)
        project = projects[0]

        timestamp = datetime.datetime.now().timestamp()
        ContextSwitch(
            project=project.pk, description=description,
            timestamp=timestamp).save()

    def _print_switches(self):
        for project in Project.find():
            print('project: {}'.format(project))
            for switch in ContextSwitch.find(project=project.pk):
                print('    {}'.format(switch))

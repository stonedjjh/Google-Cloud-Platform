from google.adk.agents.llm_agent import Agent

root_agent = Agent(
 model='gemini-2.5-flash',
 name='math_tutor_agent', # Un nombre interno más específico
 description='Ayuda a los estudiantes a aprender álgebra guiándolos a través de los pasos para la resolución de problemas.',
 instruction='Eres un tutor de matemáticas paciente. Ayuda a los estudiantes con los problemas de álgebra.'
)

from odoo import http
from odoo.http import request
import json

class XtendooAppAssistanceController(http.Controller):
    @http.route('/xtendoo/app/assistance', auth='public', type='json', methods=['POST'], csrf=False)
    def assistance(self, **kwargs):
        print("Dentro del controller")

       # print(f"Datos recibidos: {kwargs}")

        # Extraer los datos del JSON
        #telefono = kwargs.get('telefono')
        #accion = kwargs.get('accion')
        #latitud = kwargs.get('latitud')
        #longitud = kwargs.get('longitud')

        #print(f"Teléfono: {telefono}, Acción: {accion}, Posición: {latitud},{longitud}")
        # Aquí procesamos la petición de asistencia
        # Puedes acceder a los datos enviados en kwargs
        return {'status': 'success', 'message': 'Petición de asistencia recibida', 'data': kwargs}


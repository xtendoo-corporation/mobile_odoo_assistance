from odoo import http
from odoo.http import request

class XtendooAppAssistanceController(http.Controller):
    @http.route('/xtendoo/app/assistance', auth='public', type='json', methods=['POST'], csrf=False)
    def assistance(self, **kwargs):
        print("Dentro del controller")
        # Aquí procesamos la petición de asistencia
        # Puedes acceder a los datos enviados en kwargs
        return {'status': 'success', 'message': 'Petición de asistencia recibida', 'data': kwargs}


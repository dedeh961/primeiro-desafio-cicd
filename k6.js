import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 10, // número de usuários virtuais simultâneos
  duration: '30s', // duração total do teste
};

export default function () {
  const res = http.get('https://p01--github-actions--2yh8snfpzrfp.code.run/health');
  
  check(res, {
    'status é 200': (r) => r.status === 200,
  });

  sleep(1); // simula um pequeno tempo de espera entre as requisições
}

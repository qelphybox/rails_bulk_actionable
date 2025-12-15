export const request = async ({ url, ...args }) => {
  const tokenHeader = { 'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content }
  const options = {
    ...args,
    headers: args.headers ? { ...args.headers, ...tokenHeader } : tokenHeader,
  };

  const response = await fetch(url, options);

  if (!response.ok) {
    const error = new Error(response.statusText);
    error.response = response;
    throw error;
  }

  return response.json();
};

export const post = async (url, data = {}) => request({
  url,
  method: 'POST',
  body: JSON.stringify(data),
  headers: { 'Content-Type': 'application/json' },
});

export const patch = async (url, data = {}) => request({
  url,
  method: 'PATCH',
  body: JSON.stringify(data),
  headers: { 'Content-Type': 'application/json' },
});

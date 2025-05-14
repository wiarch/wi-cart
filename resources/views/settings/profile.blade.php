@extends('layouts.app')

@section('title', 'Perfil')

@section('content')

    <div class="container mx-auto py-8 max-w-3xl">
        <h2 class="text-2xl font-semibold mb-6">Profile settings</h2>

        @if (session('status') === 'verification-link-sent')
            <div class="mb-4 p-3 bg-green-100 text-green-800 rounded">
                A new verification link has been sent to your email address.
            </div>
        @endif

        <form method="POST" action="{{ route('profile.update') }}">
            @csrf
            @method('PATCH')

            <div class="mb-4">
                <label for="name" class="block font-medium mb-1">Name</label>
                <input id="name" name="name" type="text" value="{{ old('name', auth()->user()->name) }}" required
                    autocomplete="name" class="w-full rounded border-gray-300 p-2 @error('name') border-red-500 @enderror"
                    placeholder="Full name">
                @error('name')
                    <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                @enderror
            </div>

            <div class="mb-4">
                <label for="email" class="block font-medium mb-1">Email address</label>
                <input id="email" name="email" type="email" value="{{ old('email', auth()->user()->email) }}"
                    required autocomplete="username"
                    class="w-full rounded border-gray-300 p-2 @error('email') border-red-500 @enderror"
                    placeholder="Email address">
                @error('email')
                    <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                @enderror
            </div>

            @if ($mustVerifyEmail && !auth()->user()->hasVerifiedEmail())
                <div class="mb-4 text-sm text-gray-600">
                    Your email address is unverified.
                    <form method="POST" action="{{ route('verification.send') }}" class="inline">
                        @csrf
                        <button type="submit" class="underline text-blue-600 hover:text-blue-900 ml-1">
                            Click here to resend the verification email.
                        </button>
                    </form>
                </div>
            @endif

            <div class="flex items-center gap-4">
                <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
                    Save
                </button>

                @if (session('saved'))
                    <p class="text-sm text-gray-600">Saved.</p>
                @endif
            </div>
        </form>

        <hr class="my-8">

        {{-- Aquí puedes incluir tu componente o sección para eliminar usuario --}}
        {{-- @include('profile.delete-user') --}}
    </div>

@endsection
